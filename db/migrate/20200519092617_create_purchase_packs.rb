class CreatePurchasePacks < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_packs do |t|
      t.integer :pack_type, null: false, default: 0
      t.string :name, null: false, default: ''
      t.integer :credits, null: false, default: 0
      t.decimal :original_price, null: false, default: 0
      t.decimal :current_price, null: false, default: 0
      t.string :image, null: false, default: ''
      t.string :description, null: false, default: ''

      t.timestamps
    end
  end
end
