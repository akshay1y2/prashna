class Notification < ApplicationRecord
  paginates_per 10

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true

  scope :new_notifications_of_user, ->(user) { where(user: user, viewed: false) }

  after_create_commit :set_new_notifications_count_of_users

  private def set_new_notifications_count_of_user
    user.update(new_notifications_count: self.class.new_notifications_of_user(user).count)
  end
end
