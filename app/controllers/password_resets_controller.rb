class PasswordResetsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create, :edit, :update]
  before_action :find_user_by_email, only: [:create]
  before_action :set_user, only: [:edit, :update]
  before_action :validate_token, only: [:edit, :update]

  def create
    @user.send_reset_link
    redirect_to root_path, notice: 'Reset link will be sent to this email!'
  end

  def update
    if @user.update(reset_password_params)
      #FIXME_AB: we need to set token and time both to null here once updated
      redirect_to root_path, notice: "Password has been reset!"
    else
      render :edit
    end
  end

  private
    def reset_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def find_user_by_email
      @user = User.find_by(email: params[:email])
      if @user.blank?
        redirect_to password_resets_new_path, notice: 'User not found!'
      end
    end

    def set_user
      @user = User.find_by_id(params[:id])
      if @user.blank?
        redirect_to root_path, notice: 'User not found'
      end
    end

    def validate_token
      unless @user.verify_password_reset_token(params[:token])
        redirect_to root_path, notice: 'Token is either incorrect or expired!'
      end
    end
end
