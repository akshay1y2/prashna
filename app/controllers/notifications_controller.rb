class NotificationsController < ApplicationController
  def count
    render json: { count: Notification.new_notifications_of_user(params[:q]).count }
  end

  def index
    @notifications = current_user.notifications.order(:viewed, updated_at: 'desc').page(params[:page])
  end
end
