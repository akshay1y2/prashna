class ChangeContentFromCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    remove_reference :credit_transactions, :content, polymorphic: true, index: true
    add_reference :credit_transactions, :creditable, polymorphic: true, index: true
  end
end
