class Product < ApplicationRecord
  has_many :prices, dependent: :destroy

  accepts_nested_attributes_for :prices

  validates :brand, :cut, :model, :quantity, :pieces_per_package, :quality, presence: true

  def self.include_price_type(price_type)
    self.joins(:prices).where(prices: { price_type: price_type }).includes(:prices)
  end
end
