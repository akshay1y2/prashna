class Notification < ApplicationRecord
  paginates_per 10

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true

  #FIXME_AB: Lets remove count from here so that scope can be reused. Add count where it is needed. Like in controller and the private method below
  scope :new_notifications_count_of_user, ->(user) { where(user: user, viewed: false).count }

  after_create_commit :set_new_notifications_count_of_users

  private def set_new_notifications_count_of_user
    user.update(new_notifications_count: self.class.new_notifications_count_of_user(user))
  end
end
