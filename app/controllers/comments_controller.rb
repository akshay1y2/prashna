class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = current_user.comments.build(
      content: params[:comment][:content],
      commentable: @commentable
    )
    if @comment.save
      @commentable.reload
    end
  end

  private def set_commentable
    if params[:question_id] && @commentable = Question.all_published.find_by_id(params[:question_id])
    elsif params[:answer_id] && @commentable = Answer.find_by_id(params[:answer_id])
    else
      redirect_to root_path, notice: t('comment.not_saved')
    end
  end
end
