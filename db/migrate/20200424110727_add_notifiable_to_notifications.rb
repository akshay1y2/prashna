class AddNotifiableToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :notifiable, polymorphic: true, index: true
  end
end
