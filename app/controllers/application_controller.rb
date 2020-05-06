class ApplicationController < ActionController::Base
  before_action :set_user_from_remember_me_cookie
  before_action :authorize
  helper_method :current_user

  layout -> { 'admin' if current_user.present? && current_user.admin? }

  def current_user
    @_current_user
  end

  protected def authorize
    if session[:user_id] && (@_current_user = User.find_by_id(session[:user_id]))
      return
    end
    redirect_to login_url, notice: t('application.please_log_in')
    end

  protected def set_user_from_remember_me_cookie
      if cookies.permanent.signed[:user_id]
        session[:user_id] = cookies.permanent.signed[:user_id]
      end
    end
end
