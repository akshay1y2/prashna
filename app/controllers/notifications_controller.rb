class NotificationsController < ApplicationController
  def fetch
    @notifications = Notification.where(user: params[:q], viewed: false)
  end
end
