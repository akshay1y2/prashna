class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :name, default: 'other', null: false
      t.index :name, unique: true

      t.timestamps
    end


    create_join_table :users, :topics do |t|
      t.index :user_id
      t.index :topic_id

      t.timestamps
    end
  end
end
