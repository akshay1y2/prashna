class PasswordResetsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create, :edit, :update]
  before_action :find_user_by_email, only: [:create]
  before_action :set_user, only: [:edit, :update]
  before_action :validate_token, only: [:edit, :update]

  def create
    @user.send_reset_link
    redirect_to login_path, notice: t('.link_will_be_sent')
  end

  def update
    if @user.update(reset_password_params.merge(reset_token: nil, reset_sent_at: nil))
      redirect_to login_path, notice: t('.password_reset')
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
        redirect_to password_resets_new_path, notice: t('users.not_found')
      end
    end

    def set_user
      @user = User.find_by_id(params[:id])
      if @user.blank?
        redirect_to login_path, notice: t('users.not_found')
      end
    end

    def validate_token
      unless @user.verify_password_reset_token(params[:token])
        redirect_to login_path, notice: t('.unvalidated_token')
      end
    end
end
