class Notification < ApplicationRecord
  include BasicPresenter::Concern
  paginates_per 10

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true

  scope :new_notifications_of_user, ->(user) { where(user: user, viewed: false) }

  after_commit :set_new_notifications_count_of_user

  private def set_new_notifications_count_of_user
    user.update_columns(new_notifications_count: self.class.new_notifications_of_user(user).count)
  end
end
