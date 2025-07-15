module ProductScopes
  extend ActiveSupport::Concern

  include do
    scope :by_brand, -> (brands) { where(brand: brands) }
    scope :by_cut, -> (cuts) { where(cut: cuts) }
    scope :by_model, -> (models) { where(model: models) }
    scope :with_prices, -> { includes(:prices) }
  end

  def class_methods do
    def filter_by_attributes(filters)
      query = with_prices

      filters.each do |attribute, values|
        query = query.public_send("by_#{attribute}", values) if respond_to?("by_#{attribute}")
      end

      query
    end
  end
end