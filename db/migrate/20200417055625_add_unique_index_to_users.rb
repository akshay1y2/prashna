class AddUniqueIndexToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, :confirm_token
    remove_index :users, :reset_token
    add_index :users, :confirm_token, unique: true
    add_index :users, :reset_token, unique: true
    change_column :credit_transactions, :reason, :text
  end
end
