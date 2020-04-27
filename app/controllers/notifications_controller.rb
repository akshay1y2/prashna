class NotificationsController < ApplicationController
  def count
    render json: { count: Notification.new_notifications_count_of_user(params[:q]) }
  end
end
