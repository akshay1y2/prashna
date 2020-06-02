# == Schema Information
#
# Table name: purchase_packs
#
#  id             :bigint           not null, primary key
#  pack_type      :integer          default("default"), not null
#  name           :string           default(""), not null
#  credits        :integer          default(0), not null
#  original_price :decimal(, )      default(0.0), not null
#  current_price  :decimal(, )      default(0.0), not null
#  image          :string           default(""), not null
#  description    :string           default(""), not null
#  enabled        :boolean          default(TRUE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class PurchasePack < ApplicationRecord
  CURRENCY = 'INR'

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

  has_many :payment_transactions
  has_many :credit_transactions, as: :creditable

  scope :enabled, -> { where enabled: true }

  private def current_price_should_not_be_more_than_original
    if original_price < current_price
      errors.add :base, "'Current' Price cannot be more than 'Original' Price"
    end
  end
end
