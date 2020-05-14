class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_viewed]

  def poll
    new_notifications = current_user.notifications.new_notifications
    count = new_notifications.since_time(params[:time]).count
    total = count.zero? ? -1 : new_notifications.count
    render json: { count: count, total: total }
  end

  def index
    @notifications = current_user.notifications.order(created_at: 'desc').page(params[:page])
  end

  def mark_viewed
    if @notification.update(viewed: true)
      render json: { status: true, bellCount: current_user.reload.new_notifications_count }
    else
      render json: { status: false }
    end
  end

  private def set_notification
    unless @notification = current_user.notifications.find_by_id(params[:q])
      render json: { status: false }
    end
  end
end
