class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      if user.active?
        #FIXME_AB: move following code to set remember me in seperate private function. 'set_remember_me'
        #FIXME_AB: signed cookie
        #FIXME_AB: instead of parmenant cookie, set remember me cookie for 1 day
        cookies.permanent[:user_id] = user.id if params[:remember_me]
        session[:user_id] = user.id
        redirect_to root_path, notice: "Welcome #{user.name}"
      else
        redirect_to root_path, notice: "User: #{user.name}, not activated!"
      end
    else
      redirect_to login_url, notice: "Invalid email/password combination"
    end
  end

  def destroy
    #FIXME_AB: use reset_session
    session[:user_id] = nil
    #FIXME_AB: private method clear_remember_me
    cookies.permanent[:user_id] = nil
    redirect_to root_path, notice: "Logged out"
  end
end
