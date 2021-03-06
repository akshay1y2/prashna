class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :create_comment]
  before_action :set_user_for_question, only: [:index]
  before_action :check_if_user_has_credits, only: [:new, :create]
  before_action :verify_user, only: [:edit, :update, :destroy]

  def index
    @questions = get_questions_for_index.includes([:attachment_attachment, :comments]).page(params[:page])
  end

  def show
  end

  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
    @topics = @question.topic_names.join(', ')
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = current_user.questions.build(question_params)
    set_question_parameters
    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: t(".#{@question.published? ? 'published' : 'saved'}") }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    set_question_parameters
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: t('.updated') }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: t('.destroyed') }
      format.json { head :no_content }
    end
  end

  def drafts
    @questions = current_user.questions.unpublished.page(params[:page])
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_question
    @question = Question.includes([:user, :comments]).find_by_id(params[:id])
    if @question.blank?
      redirect_to root_path, notice: t('.question_not_found')
    end
  end

  # Only allow a list of trusted parameters through.
  private def question_params
    params.require(:question).permit(:attachment, :title, :content)
  end

  private def set_question_parameters
    @topics = params[:question][:topics]
    @question.set_topics @topics
    @question.new_publish = true unless(@question.published? || params[:question][:publish] == '0')
  end

  private def verify_user
    unless @question.posted_by?(current_user)
      redirect_to root_path, notice: t('.access_denied')
    end
  end

  private def check_if_user_has_credits
    if current_user.credits < ENV['ask_question_credit'].to_i
      redirect_to root_path, notice: t('.not_enough_credits')
    end
  end

  private def set_user_for_question
    if params[:user].present? && !(@user = User.find_by_id(params[:user]))
      redirect_to root_path, notice: t('.user_not_found')
    end
  end

  private def get_questions_for_index
    questions = Question.published.includes([:user])
    if params[:search].present?
      @search = params[:search]
      questions = questions.where id: Question.search_for_ids(params[:search])
    elsif params[:topic].present?
      questions = questions.joins(:questions_topics).where(questions_topics: { topic_id: Topic.by_names([params[:topic]]) })
    elsif params[:user].present?
      questions = @user.questions
    end
    questions.distinct.order(published_at: 'desc')
  end
end
