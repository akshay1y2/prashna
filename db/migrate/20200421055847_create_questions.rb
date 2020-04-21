class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title, default: '', null: false
      t.text :content, default: '', null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :published_at
      t.bigint :comments_count, default: 0, null: false
      t.bigint :answers_count,  default: 0, null: false
      t.bigint :vote_count,     default: 0, null: false
      t.bigint :upvote_count,   default: 0, null: false
      t.bigint :downvote_count, default: 0, null: false
      t.index [ :title ], unique: true

      t.timestamps
    end

    create_join_table :questions, :topics do |t|
      t.index :question_id
      t.index :topic_id

      t.timestamps
    end
  end
end
