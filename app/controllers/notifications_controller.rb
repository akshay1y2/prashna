class NotificationsController < ApplicationController
  def fetch
    #FIXME_AB: both lines below are same I guess??
    @notifications = Notification.where(user: params[:q], viewed: false)
    current_user.notifications.where(viewed: false)
  end
end
