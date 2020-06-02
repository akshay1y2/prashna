class AnswersController < ApplicationController
  before_action :set_question, only: [:create]

  def create
    @answer = current_user.answers.build(
      content: params[:answer][:content],
      question: @question
    )
    @answer.save
    render 'index', locals: { question: @question }, layout: false
  end

  private def set_question
    @question = Question.published.find_by_id(params[:question_id])
    if @question.blank?
      redirect_to root_path, notice: t('.question_not_found')
    end
  end
end
