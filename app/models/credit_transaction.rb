class CreditTransaction < ApplicationRecord
  include NotDeleteable
  belongs_to :user
  belongs_to :creditable, polymorphic: true

  validates :credits, numericality: true
  validates :reason, presence: true

  after_commit :update_user_credits

  private
    def update_user_credits
      user.update(credits: user.credit_transactions.sum('credits'))
    end
end