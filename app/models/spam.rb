class Spam < ApplicationRecord
  validate :spammed_by_only_one_user

  belongs_to :user
  belongs_to :spammable, polymorphic: true

  def spammed_by_only_one_user
    if self.class.where(user: user, spammable: spammable).present?
      errors.add(:base, 'You have already spammed this once.')
    end
  end
end
