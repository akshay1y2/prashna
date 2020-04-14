class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verification.subject
  #
  def verification
    @user = User.find(params[:id])
    if @user && !@user.active?
      mail to: @user.email, subject: 'Account Confirmation-Token'
    end
  end

  def reset_password
    @user = User.find(params[:id])
    if @user
      mail to: @user.email, subject: 'Password Reset Link'
    end
  end
end
