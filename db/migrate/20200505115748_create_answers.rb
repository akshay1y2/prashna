class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.text :content, default: '', null: false
      t.belongs_to :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :comments_count, default: 0, null: false
      t.integer :net_upvotes, default: 0, null: false

      t.timestamps
    end
  end
end
