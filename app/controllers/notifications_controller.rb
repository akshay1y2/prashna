class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_viewed]

  def count
    render json: { count: Notification.new_notifications_of_user(current_user).count }
  end

  def index
    @notifications = current_user.notifications.order(created_at: 'desc').page(params[:page])
  end

  def mark_viewed
    if @notification.update(viewed: true)
      render json: { status: true, bellCount: current_user.new_notifications_count }
    else
      render json: { status: false }
    end
  end

  private def set_notification
    unless @notification = Notification.find_by_id(params[:q])
      render json: { status: false }
    end
  end
end
