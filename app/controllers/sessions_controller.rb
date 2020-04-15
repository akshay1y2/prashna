class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      if user.active?
        set_remember_me(user.id)
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
    reset_session
    clear_remember_me_cookie
    redirect_to root_path, notice: "Logged out"
  end

  private
    def set_remember_me(id)
      if params[:remember_me]
        #FIXME_AB: Lets take this expiry number of days from env/figaro
        cookies.permanent.signed[:user_id] = { value: id, expires: 1.day.from_now }
      end
    end

    def clear_remember_me_cookie
      cookies.delete(:user_id)
    end
end
