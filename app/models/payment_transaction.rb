class PaymentTransaction < ApplicationRecord
  include NotDeleteable

  belongs_to :payable, polymorphic: true
  belongs_to :user
end
