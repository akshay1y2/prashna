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

  after_commit :unpublish_spammable_and_revert_credits

  scope :for_spammable, ->(spammable) { where spammable: spammable }

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

  private def unpublish_spammable_and_revert_credits
    if self.class.for_spammable(spammable).size >= ENV['net_abuse_reports_to_spam'].to_i
      spammable.update_column(:marked_abuse, true)

      credits_earned = spammable.credit_transactions.sum(:credits)
      if credits_earned.positive?
        spammable.credit_transactions.create!(
          user_id: spammable.user_id,
          credits: -1 * credits_earned,
          reason: 'marked_abuse'
        )
      end
    end
  end
end
