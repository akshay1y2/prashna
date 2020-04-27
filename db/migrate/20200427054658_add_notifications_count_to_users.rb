class AddNotificationsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :new_notifications_count, :integer, default: 0, null: false
  end
end
