class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :name, default: 'other', null: false
      t.index :name

      t.timestamps
    end


    create_table :topics_users, id: false do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
