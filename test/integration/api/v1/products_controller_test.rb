require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = @user.api_tokens.create!
    @product = products(:product_one)
    @client = clients(:three)
  end

  test "whent auth token is not valid" do
    get api_v1_products_path
    assert_response :unauthorized
  end

  test "get products index without query params" do
    get api_v1_products_path, headers: { HTTP_AUTHORIZATION: "Token token=#{@token.token}" }
    assert_response :success
    json_response = JSON.parse(response.body)

    assert json_response.include?(@product.as_json(include: :prices))
    assert_equal json_response.size, 10
  end

  test "get products filtered by brand and include price 1" do
    @product9 = products(:product_nine)
    @product10 = products(:product_ten).as_json
    @prices_one_product10 = prices(:product_ten_one).as_json
    @product10["prices"] = [ @prices_one_product10 ]

    get api_v1_products_path, headers: { HTTP_AUTHORIZATION: "Token token=#{@token.token}" }, params: { brand: "#{@product9.brand},#{@product10["brand"]}" }
    json_response = JSON.parse(response.body)

    assert_equal json_response.size, 2
    assert_equal @product10, json_response.select { |p| p["id"] ==  @product10["id"] }.first
  end

  test "get products filtered by brands" do
    @product = products(:product_one).as_json # CLOUD MEN
    @price_one_product1 = prices(:product_one_one).as_json
    @product["prices"] = [ @price_one_product1 ]

    get api_v1_products_path, headers: { HTTP_AUTHORIZATION: "Token token=#{@token.token}" }, params: { brand: @product["brand"] }
    json_response = JSON.parse(response.body)

    assert_equal json_response.size, 2
    assert_equal @product, json_response.select { |p| p["id"] == @product["id"] }.first
  end

  test "get products filtered by cut" do
    @product = products(:product_four).as_json # FLARE
    @price = prices(:product_four_one).as_json
    @product["prices"] = [ @price ]

    get api_v1_products_path, headers: { HTTP_AUTHORIZATION: "Token token=#{@token.token}" }, params: { cut: @product["cut"] }

    json_response = JSON.parse(response.body)
    assert_equal json_response.size, 1
    assert_equal @product, json_response.first
  end

  test "get products filtered by models, and get price 3" do
    @product = products(:product_one).to_json # AX82-W
    @product10 = products(:product_ten) # M128
    @product_not = products(:product_two)
    @price = prices(:product_one_three)
    @client.price_type = @price.price_type

    get api_v1_products_path, headers: { HTTP_AUTHORIZATION:
    "Token token=#{@token.token}" }, params: {
      model: "#{@product["model"]},#{@product10["model"]}",
      phone: @client.phone
    }
    json_response = JSON.parse(response.body)
    products_ids = json_response.map { |p| p["id"] }

    assert products_ids - [ @product["id"], @product10["id"] ]
    assert_not products_ids.include? @product_not.id
    assert_equal json_response.first["prices"].first["price_type"], @price.price_type
  end
end
