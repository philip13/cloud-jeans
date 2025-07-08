class CreatePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :prices do |t|
      t.references :product, null: false, foreign_key: true
      t.string :price_type
      t.string :description
      t.decimal :value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
