class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      if user.active?
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
    session[:user_id] = nil
    cookies.permanent[:user_id] = nil
    redirect_to root_path, notice: "Logged out"
  end
end
