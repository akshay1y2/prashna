class SpamsController < ApplicationController
  before_action :set_spammable

  def create
    spam = current_user.spams.build(
      reason: params[:spam][:reason],
      spammable: @spammable
    )
    if spam.save
      render json: {status: true, message: 'Reported as spam'}
    else
      render json: {status: false, message: spam.errors.full_messages[0]}
    end
  end

  private def set_spammable
    spammable = params[:spammable].split('-')
    if spammable[0] == 'question' && @spammable = Question.find_by_id(spammable[1])
    elsif spammable[0] == 'answer' && @spammable = Answer.find_by_id(spammable[1])
    elsif spammable[0] == 'comment' && @spammable = Comment.find_by_id(spammable[1])
    else
      render json: {status: false, message: 'Can not find what you are spamming.'}
    end
  end
end
