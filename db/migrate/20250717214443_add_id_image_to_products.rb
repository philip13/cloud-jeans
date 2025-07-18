class AddIdImageToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :id_image, :string
  end
end
