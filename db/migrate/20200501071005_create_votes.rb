class CreateVotes < ActiveRecord::Migration[6.0]
    def change
      create_table :votes do |t|
        t.integer :vote_type, default: 0, null: false
        t.references :votable, polymorphic: true, index: true
        t.belongs_to :user, null: false, foreign_key: true
  
        t.timestamps
      end
  
    remove_column :questions, :vote_count, :integer, default: 0, null: false
    remove_column :questions, :upvote_count, :integer, default: 0, null: false
    remove_column :questions, :downvote_count, :integer, default: 0, null: false
    remove_column :comments, :vote_count, :integer, default: 0, null: false
    remove_column :comments, :upvote_count, :integer, default: 0, null: false
    remove_column :comments, :downvote_count, :integer, default: 0, null: false
    add_column :questions, :net_upvotes, :integer, default: 0, null: false
    add_column :comments, :net_upvotes, :integer, default: 0, null: false
  end
end
