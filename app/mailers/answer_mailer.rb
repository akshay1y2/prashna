class AnswerMailer < ApplicationMailer
  def new_answer_posted(id)
    if @answer = Answer.find_by_id(id)
      @question = @answer.question
      mail to: @question.user.email, subject: t('.subject')
    end
  end
end
