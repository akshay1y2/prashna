class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = @commentable.comments.new(content: params[:comment][:content], user: current_user)
    unless @comment.save
      if @comment.errors.of_kind? :content, "can't be blank"
        message = t('comment.blank')
      else
        message = t('comment.not_saved')
      end
      redirect_to @commentable, notice: message
    end
  end

  private def set_commentable
    if params[:question_id].present?
      @commentable = Question.find_by_id(params[:question_id])
      if @commentable.blank?
        redirect_to root_path, notice: t('.question_not_found')
      end
    elsif params[:answer_id].present?
    else
      redirect_to root_path, notice: t('comment.not_saved')
    end
  end
end
