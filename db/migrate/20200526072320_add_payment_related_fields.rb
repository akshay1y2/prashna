class AddPaymentRelatedFields < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_packs, :enabled, :boolean, null: false, default: true

    add_column :users, :stripe_token, :string

    remove_reference :payment_transactions, :payable, polymorphic: true
    add_reference :payment_transactions, :purchase_pack, foreign_key: true
    add_column :payment_transactions, :status, :integer, null: false, default: 0
    add_column :payment_transactions, :token, :string
    add_column :payment_transactions, :charge_id, :string
    add_column :payment_transactions, :error_message, :string
    add_column :payment_transactions, :customer_id, :string
  end
end
