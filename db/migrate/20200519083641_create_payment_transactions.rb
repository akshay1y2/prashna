class CreatePaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_transactions do |t|
      t.integer :credits, null: false, default: 0
      t.belongs_to :user, null: false, foreign_key: true
      t.references :payable, polymorphic: true

      t.timestamps
    end
  end
end
