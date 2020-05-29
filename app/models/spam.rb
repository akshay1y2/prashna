# == Schema Information
#
# Table name: spams
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  spammable_type :string
#  spammable_id   :bigint
#  reason         :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Spam < ApplicationRecord
  validate :spammed_by_only_one_user, :cannot_spam_own_content

  belongs_to :user
  belongs_to :spammable, polymorphic: true

  private def spammed_by_only_one_user
    if self.class.where(user: user, spammable: spammable).present?
      errors.add(:base, I18n.t('spam.errors.already_spammed'))
    end
  end

  private def cannot_spam_own_content
    if user == spammable.user
      errors.add(:base, I18n.t('spam.errors.spamming_own'))
    end
  end
end
