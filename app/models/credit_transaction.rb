class CreditTransaction < ApplicationRecord
  belongs_to :user

  validates :credits, numericality: true
  validates :reason, presence: true

  after_commit :update_user_credits, on: [:create, :update]

  private
    def update_user_credits
      user.update(credits: user.credit_transactions.sum('credits'))
    end
end