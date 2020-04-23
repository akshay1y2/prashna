class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :verify_user, only: [:edit, :update, :destroy]

  def index
    #FIXME_AB: lets show questions that are:
    #FIXME_AB: 1. published
    #FIXME_AB: 2. by any user
    #FIXME_AB: 3. instead of table type list. Lets present them in a better way like quora.
    #FIXME_AB: 4. paginated list. Use kaminari gem
    @questions = current_user.questions
    #FIXME_AB: questions index should be the default root. means localhost:3000 should display questions
    #FIXME_AB: user's unpublished/draft questions should be displayed in seperate action and the link for this should be displayed on profile page
  end

  def show
  end

  def new
    @question = Question.new
    #FIXME_AB: add a button in the top navigation "New Question" if user is logged in.
  end

  # GET /questions/1/edit
  def edit
    #FIXME_AB: before action to check whether it can be edited or not.
    @topics = @question.topic_names.join(', ')
  end

  # POST /questions
  # POST /questions.json
  def create
    #FIXME_AB: use current_user.questions.build
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
    #FIXME_AB: before action to check whether it can be edited or not.
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
    #FIXME_AB: what if not found?
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
      #FIXME_AB: setting published_at should be done as before save callback. you need params :publish for that, you can create a virtual attribute using attr_acessor in questoins model. you just sat topics and that virtual attribute here
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
    #FIXME_AB: this should be done from model callback
    @question.topics.joins(:topics_users).distinct.pluck('topics_users.user_id').each do |id|
      Notification.create(user_id: id, message: '.new_question')
    end
    ActionCable.server.broadcast 'questions', json: { msg: @question.topic_names, time: Time.current.strftime("%-d/%-m/%y: %H:%M %Z") }
  end
end
