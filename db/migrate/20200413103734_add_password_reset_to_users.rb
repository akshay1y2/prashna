class AddPasswordResetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_token, :string
    add_column :users, :reset_sent_at, :datetime
  end
end
