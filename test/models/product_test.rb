require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:product_one)
  end

  test "valid product" do
    assert @product.valid?
  end

  test "invalide without brand" do
    @product.brand = nil
    refute @product.valid?
  end

  test "invalid without cut" do
    @product.cut = nil
    refute @product.valid?
  end

  test "invalid without model" do
    @product.model = nil
    refute @product.valid?
  end

  test "invalid without pieces_per_package" do
    @product.pieces_per_package = nil
    refute @product.valid?
  end

  test "invalid without quantity" do
    @product.quantity = nil
    refute @product.valid?
  end

  test "valid with packaging_type" do
    @product = products(:product_one)
    @product.packaging_type = "CAJA"
    assert @product.valid?
  end

  test "product could have id_image" do
    @product.id_image = "1uIy8qMgKmNCyhobc5SRVmNpLC2UF0E3M"
    assert @product.valid?
    @product.id_image = nil
    assert @product.valid?
  end
end
