class AnswersController < ApplicationController
  before_action :set_question, only: [:create]

  def create
    @answer = Answer.new(content: params[:answer][:content], user: current_user, question: @question)
    if @answer.validate
      notice = 'Answer submitted'
    else
      notice = 'not submitted'
    end
    redirect_to @question, notice: notice
  end

  private def set_question
    @question = Question.find_by_id(params[:question_id])
    if @question.blank?
      redirect_to root_path, notice: t('.question_not_found')
    end
  end
end
