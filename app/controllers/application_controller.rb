class ApplicationController < ActionController::Base
  before_action :set_user_from_remember_me_cookie
  before_action :authorize

  protected
    def authorize
      if session[:user_id]
        @user = User.find_by_id(session[:user_id])
        return if @user.present?
      end
      redirect_to login_url, notice: t('application.please_log_in')
    end

    def set_user_from_remember_me_cookie
      if cookies.permanent.signed[:user_id]
        session[:user_id] = cookies.permanent.signed[:user_id]
      end
    end
end
