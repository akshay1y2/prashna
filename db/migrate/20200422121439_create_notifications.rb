class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :message, default: '', null: false
      t.boolean :viewed, default: false, null: false

      t.timestamps
    end
  end
end
