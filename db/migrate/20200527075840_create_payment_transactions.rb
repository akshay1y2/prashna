class CreatePaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_transactions do |t|
      t.integer :credits, null: false, default: 0
      t.belongs_to :purchase_pack, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.decimal :amount, default: 0, null: false
      t.integer :status, null: false, default: 0
      t.string :stripe_token
      t.string :charge_id
      t.string :error_message

      t.timestamps
    end
  end
end
