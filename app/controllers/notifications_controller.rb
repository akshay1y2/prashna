class NotificationsController < ApplicationController
  def fetch
    render json: { count: Notification.where(user: params[:q], viewed: false).count }
  end
end
