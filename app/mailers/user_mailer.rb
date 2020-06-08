class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verification.subject
  #
  def verification(id)
    @user = User.find(id)
    if @user && !@user.active?
      mail to: @user.email, subject: t('.subject')
    end
  end

  def reset_password(id)
    @user = User.find(id)
    if @user
      mail to: @user.email, subject: t('.subject')
    end
  end
end
