class AddIndexToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :confirm_token
    add_index :users, :reset_token
  end
end
