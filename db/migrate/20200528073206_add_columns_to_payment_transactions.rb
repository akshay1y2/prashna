class AddColumnsToPaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_transactions, :paid_at, :datetime
    add_column :payment_transactions, :refunded_at, :datetime
    add_column :payment_transactions, :charge_response, :jsonb, null: false, default: {}
  end
end
