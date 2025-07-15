# app/services/product_filter_service.rb

class ProductFilterService
  def initialize(filters, price_type)
    @filters = filters
    @price_type = price_type
  end

  def call
    build_query.include_price_type(@price_type)
  end

  private

  def build_query
    query = Product.includes(:prices)

    @filters.each do |field, values|
      query = query.where(field => values)
    end

    query
  end
end
