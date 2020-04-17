class CreateCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_transactions do |t|
      t.integer :credits, default: 0, null: false
      t.string :reason, default: 'other', null: false
      t.references :content, polymorphic: true
      t.belongs_to :user, foreign_key: true
      t.index :reason
      t.timestamps
    end
  end
end
