class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :cut
      t.string :model
      t.integer :quantity
      t.integer :pieces_per_package
      t.string :quality
      t.string :description

      t.timestamps
    end
  end
end
