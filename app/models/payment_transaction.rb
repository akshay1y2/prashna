class PaymentTransaction < ApplicationRecord
  include NotDeleteable
  paginates_per 10

  validates :amount, :credits, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :payable, polymorphic: true
  belongs_to :user
end
