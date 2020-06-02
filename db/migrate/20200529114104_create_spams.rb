class CreateSpams < ActiveRecord::Migration[6.0]
  def change
    create_table :spams do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.references :spammable, polymorphic: true
      t.string :reason, null: false, default: ''

      t.timestamps
    end
  end
end
