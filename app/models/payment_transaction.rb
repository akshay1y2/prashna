class PaymentTransaction < ApplicationRecord
  include NotDeleteable
  paginates_per 10

  #FIXME_AB: should have states. pending, after stripe payment mark paid, when marked paid, then assign credits

  validates :amount, :credits, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :payable, polymorphic: true
  belongs_to :user
end
