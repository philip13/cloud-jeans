class Client < ApplicationRecord
  validates :first_name, :last_name, :phone, :price_type, presence: true
  validates :email, :phone, presence: true, uniqueness: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
end
