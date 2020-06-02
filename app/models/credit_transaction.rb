# == Schema Information
#
# Table name: credit_transactions
#
#  id              :bigint           not null, primary key
#  credits         :integer          default(0), not null
#  reason          :text             default("other"), not null
#  user_id         :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creditable_type :string
#  creditable_id   :bigint
#
class CreditTransaction < ApplicationRecord
  include NotDeleteable
  paginates_per 10

  belongs_to :user
  belongs_to :creditable, polymorphic: true

  validates :credits, numericality: true
  validates :reason, presence: true

  after_commit :update_user_credits

  private
    def update_user_credits
      user.update_columns(credits: user.credit_transactions.sum('credits'))
    end
end
