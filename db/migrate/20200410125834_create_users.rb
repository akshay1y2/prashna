class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :role, null: false, default: 1
      t.integer :credits, null: false, default: 0

      t.timestamps
    end
  end
end
