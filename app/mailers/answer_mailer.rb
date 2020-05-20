class AnswerMailer < ApplicationMailer
  def new_answer_posted
    if @answer = Answer.find_by_id(params[:id])
      @question = @answer.question
      mail to: @question.user.email, subject: t('.subject')
    end
  end
end
