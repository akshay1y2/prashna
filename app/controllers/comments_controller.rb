class CommentsController < ApplicationController
  before_action :set_question

  def create
    @comment = @question.comments.new(content: params[:comment][:content], user: current_user)
    unless @comment.save
      if @comment.errors.of_kind? :content, "can't be blank"
        message = t('comment.blank')
      else
        message = t('comment.not_saved')
      end
      redirect_to @question, notice: message
    end
  end

  private def set_question
    @question = Question.find_by_id(params[:id])
    if @question.blank?
      redirect_to root_path, notice: t('.question_not_found')
    end
  end
end
