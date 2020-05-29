# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  message         :string           default(""), not null
#  viewed          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_type :string
#  notifiable_id   :bigint
#
class Notification < ApplicationRecord
  include BasicPresenter::Concern
  paginates_per 10

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true

  scope :new_notifications, ->{ where(viewed: false) }
  scope :since_time, ->(time) { where('created_at > ?', time) }

  after_commit :set_new_notifications_count_of_user

  private def set_new_notifications_count_of_user
    user.refresh_new_notification_count!
  end
end
