class PaymentTransaction < ApplicationRecord
  include NotDeleteable
  paginates_per 10

  #FIXME_AB: refunded
  enum status: { pending: 0, failed: 1, paid: 2 }

  validates :amount, :credits, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :purchase_pack
  belongs_to :user

  #FIXME_AB: save charge info. card details. charge_id

  #FIXME_AB: refund! => if paid  then refund on stripe and reverse the credit transaction
  #FIXME_AB: payment.refund!

  #FIXME_AB: record paid at and refunded at
  #FIXME_AB: send customer email on payment success or refund
end
