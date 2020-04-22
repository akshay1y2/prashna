class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :verify_user, only: [:edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    @questions = current_user.questions
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
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
    @question = Question.new(question_params)
    @question.user = current_user
    set_question_parameters

    respond_to do |format|
      if @question.save
        notify_users if @should_notify_users
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
        notify_users if @should_notify_users
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


    # Use callbacks to share common setup or constraints between actions.
  private def set_question
    @question = Question.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  private def question_params
    params.require(:question).permit(:attachment, :title, :content)
  end

  private def set_question_parameters
    @topics = params[:question][:topics]
    @question.set_topics @topics
    unless @question.published? || params[:question][:publish] == '0'
      @question.published_at = Time.current
      @should_notify_users = true
    end
  end

  private def verify_user
    unless current_user.id == @question.user.id
      redirect_to questions_path, notice: t('.access_denied')
    end
  end

  private def notify_users
    @question.topics.joins(:topics_users).distinct.pluck('topics_users.user_id').each do |id|
      Notification.create(user_id: id, message: '.new_question')
    end
    ActionCable.server.broadcast 'questions', json: { msg: @question.topic_names, time: Time.current.strftime("%-d/%-m/%y: %H:%M %Z") }
  end
end
