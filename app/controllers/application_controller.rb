class ApplicationController < ActionController::Base
  before_action :set_user_id_in_session
  before_action :authorize

  protected
    def authorize
      #FIXME_AB: what if session don't have user_id
      @user = User.find_by_id(session[:user_id])
      unless @user
        redirect_to login_url, notice: "Please log in."
      end
    end

    def set_user_id_in_session
      #FIXME_AB: make this a signed cookie
      if session[:user_id].blank? && cookies.permanent[:user_id].present?
        session[:user_id] = cookies.permanent[:user_id]
      end
    end
end
