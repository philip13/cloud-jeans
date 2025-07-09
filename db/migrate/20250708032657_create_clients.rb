class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :price_type

      t.timestamps
    end
  end
end
