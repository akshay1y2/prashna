class PurchasePack < ApplicationRecord
  #FIXME_AB: make a rake task to seed few packs
  enum pack_type: {
    default: 0,
    single: 1,
    combo: 2
  }

  validates :pack_type, :image, :description, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :credits, numericality: { greater_than: 0 }
  validates :original_price, :current_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :current_price_should_not_be_more_than_original

  has_many :payment_transactions, as: :payable
  has_many :credit_transactions, as: :creditable

  #FIXME_AB: add a field enabled: boolean. Only enabled one should be purchasable

  private def current_price_should_not_be_more_than_original
    errors.add :base, "'Current' Price cannot be more than 'Original' Price" if original_price < current_price
  end
end
