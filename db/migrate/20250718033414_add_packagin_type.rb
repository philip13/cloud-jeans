class AddPackaginType < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :packaging_type, :string
  end
end
