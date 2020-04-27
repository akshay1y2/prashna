class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :create_comment, :index_comments]
  before_action :check_if_user_has_credits, only: [:new, :create]
  before_action :verify_user, :check_if_question_is_updatable, only: [:edit, :update, :destroy]

  def index
    @questions = get_questions_for_index.page(params[:page])
  end

  def show
    @comment = Comment.new
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
    @questions = Question.all_unpublished.page(params[:page])
  end

  def create_comment
    @comment = @question.comments.new(content: params[:comment][:content], user: current_user)
    if @comment.save
      redirect_to @question, notice: 'posted'
    else
      if @comment.errors[:content] == ["can't be blank"]
        message = t('comment.blank')
      else
        message = t('comment.not_saved')
      end
      redirect_to @question, notice: message
    end
  end

  def index_comments
    @comments = @question.comments
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_question
    @question = Question.find_by_id(params[:id])
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
    unless current_user.id == @question.user.id
      redirect_to root_path, notice: t('.access_denied')
    end
  end

  private def check_if_user_has_credits
    if current_user.credits < 1
      redirect_to root_path, notice: t('.not_enough_credits')
    end
  end

  private def check_if_question_is_updatable
    #FIXME_AB: we can move this in a before update and destroy callback
    if @question.vote_count > 0 || @question.answers_count > 0 || @question.comments_count > 0
      redirect_to root_path, notice: t('.not_updateable')
    end
  end

  private def get_questions_for_index
    questions = Question.all_published.order(published_at: 'desc')
    if params[:title].present?
      questions = questions.by_title(params[:title])
    end
    if params[:topics].present?
      #FIXME_AB: extract to a method in topic model Topic.get_ids_by_name. Since we need only ids so use pluck id
      questions = questions.joins(:topics).where(topics: {id: Topic.by_names(params[:topics].split(",").map(&:strip).reject(&:empty?))})
    end
    questions
  end
end
