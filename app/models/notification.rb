class Notification < ApplicationRecord
  belongs_to :user

  #FIXME_AB: this should also belongs_to question. use polymorphic so that this model can be resused
  validates :message, presence: true
end
