class PaymentTransaction < ApplicationRecord
  include NotDeleteable
  paginates_per 10

  enum status: { pending: 0, failed: 1, paid: 2 }

  validates :amount, :credits, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :purchase_pack
  belongs_to :user
end
