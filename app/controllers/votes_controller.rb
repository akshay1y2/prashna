class VotesController < ApplicationController
  before_action :set_votable, only: [:create]

  def create
    @vote = Vote.find_or_initialize_by(votable: @votable, user: current_user)
    @vote.vote_type = params[:vote]
    unless @vote.save
      redirect_to root_path, notice: t('.not_saved')
    end
  end

  private def set_votable
    if params[:question] && @votable = Question.find_by_id(params[:question])
    elsif params[:comment] && @votable = Comment.find_by_id(params[:comment])
    elsif params[:answer] && @votable = Answer.find_by_id(params[:answer])
    else
      redirect_to root_path, notice: t('.not_found')
    end
  end
end
