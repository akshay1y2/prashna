class AnswersController < ApplicationController
  before_action :set_question, only: [:create]

  def create
    #FIXME_AB: form should not be cleared when error
    @answer = current_user.answers.build(
      content: params[:answer][:content],
      question: @question
    )
    @answer.save
    render 'index', locals: { question: @question }, layout: false
  end

  private def set_question
    #FIXME_AB: Answer should be saved for published question only. add this check in controller by adding Question.published.find_by...
    @question = Question.find_by_id(params[:question_id])
    if @question.blank?
      redirect_to root_path, notice: t('.question_not_found')
    end
  end
end
