class Product < ApplicationRecord
  has_many :prices, dependent: :destroy

  accepts_nested_attributes_for :prices

  validates :brand, :cut, :model, :quantity, :pieces_per_package, :quality, presence: true

  def self.product_price_type price_type
    Product.joins(:prices).where(prices: { price_type: price_type }).includes(:prices)
  end

  def packaging_type?
    self.pieces_per_package == 24 ? 'Caja': 'Paquete'
  end
end
