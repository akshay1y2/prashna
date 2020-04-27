class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false, default: ''
      t.belongs_to :user, null: false, foreign_key: true
      t.references :commentable, polymorphic: true, index: true
      t.bigint :vote_count,     default: 0, null: false
      t.bigint :upvote_count,   default: 0, null: false
      t.bigint :downvote_count, default: 0, null: false

      t.timestamps
    end
  end
end
