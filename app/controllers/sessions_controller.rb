class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      if user.active?
        set_remember_me(user.id)
        session[:user_id] = user.id
        redirect_to root_path, notice: t('.welcome', name: user.name)
      else
        redirect_to login_url, notice: t('.not_active', name: user.name)
      end
    else
      redirect_to login_url, notice: t('.invalid_credentials')
    end
  end

  def destroy
    reset_session
    clear_remember_me_cookie
    redirect_to root_path, notice: t('.logout')
  end

  private
    def set_remember_me(id)
      if params[:remember_me]
        cookies.permanent.signed[:user_id] = { 
          value: id,
          expires: ENV['cookie_expiry_days'].to_i.day.from_now
        }
      end
    end

    def clear_remember_me_cookie
      cookies.delete(:user_id)
    end
end
