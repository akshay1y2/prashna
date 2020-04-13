class AddConfirmTokenToUsers < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :role, :boolean, null: false, default: false
    add_column :users, :state, :boolean, null: false, default: false
    add_column :users, :confirm_token, :string
  end

  def down
    remove_column :users, :confirm_token, :string
    remove_column :users, :state, :boolean
    change_column :users, :role, :integer, null: false, default: 1
  end
end
