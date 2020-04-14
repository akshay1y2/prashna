class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verification.subject
  #
  def verification
    @user = User.find(params[:id])
    if @user && @user.inactive?
      #FIXME_AB: use mail interceptor to prepend rails env to the mail subject other than production env
      #FIXME_AB: https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-and-observing-emails
      mail to: @user.email, subject: '[staging] Account Confirmation-Token'
    end
  end

  def reset_password
    @user = User.find(params[:id])
        if @user
      mail to: @user.email, subject: 'Password Reset Link'
    end
  end
end
