class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :admin, null: false, default: false
      t.integer :credits, null: false, default: 0
      t.boolean :active, null: false, default: false
      t.string :confirm_token
      t.string :reset_token
      t.datetime :reset_sent_at
      t.index :email

      t.timestamps
    end
  end
end
