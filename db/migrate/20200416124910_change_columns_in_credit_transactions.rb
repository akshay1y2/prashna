class ChangeColumnsInCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :credit_transactions, :user_id, false
    remove_index :credit_transactions, :reason
  end
end
