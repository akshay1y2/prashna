class PasswordResetsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_reset_link if user
    redirect_to root_path, notice: 'Reset link will be sent to this email!'
  end

  def edit
    @user = User.find_by_id(params[:id])
    unless @user
      redirect_to root_path, notice: 'User not found' and return
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    unless @user.reset_token == params[:token]
      redirect_to password_resets_new_path, :notice => "Reset Token is Incorrect." and return
    end
    if @user.reset_sent_at < 2.hours.ago
      redirect_to password_resets_new_path, :notice => "Password reset has expired." and return
    end
    if @user.update(passwords)
      redirect_to root_path, :notice => "Password has been reset!"
    else
      render :edit
    end
  end

  private
    def passwords
      params.require(:user).permit(:password, :password_confirmation)
    end
end