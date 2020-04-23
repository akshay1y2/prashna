class NotificationsController < ApplicationController
  def fetch
    @notifications = Notification.where(user: params[:q], viewed: false)
    current_user.notifications.where(viewed: false)
  end
end
