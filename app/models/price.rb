class Price < ApplicationRecord
  belongs_to :product

  validates :price_type, :value, presence: true

  validates :value, numericality: { greater_than_or_equal_to: 1}
end
