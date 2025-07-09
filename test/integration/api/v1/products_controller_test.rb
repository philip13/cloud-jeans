require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = @user.api_tokens.create!
    @product = products(:one)
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

  test "get products filtered by brand" do
    @product9 = products(:nine)
    @product10 = products(:ten)

    get api_v1_products_path, headers: { HTTP_AUTHORIZATION: "Token token=#{@token.token}" }, params: { brand: "#{@product9.brand},#{@product10.brand}" }
    json_response = JSON.parse(response.body)
    assert_equal json_response.size, 2
    assert json_response.include?(@product9.as_json(include: :prices))
    assert json_response.include?(@product10.as_json(include: :prices))
  end

  test "get products filtered by brands" do
    @product = products(:ten) # CLOUD MEN
    get api_v1_products_path, headers: { HTTP_AUTHORIZATION: "Token token=#{@token.token}" }, params: { brand: @product.brand }
    json_response = JSON.parse(response.body)
    assert_equal json_response.size, 1
    assert json_response.include?(@product.as_json(include: :prices))
  end

  test "get products filtered by cut" do
    @product = products(:four) # FLARE
    get api_v1_products_path, headers: { HTTP_AUTHORIZATION: "Token token=#{@token.token}" }, params: { cut: @product.cut }

    json_response = JSON.parse(response.body)
    assert_equal json_response.size, 1
    assert json_response.include?(@product.as_json(include: :prices))
  end

  test "get products filtered by models" do
    @product = products(:one) # AX82-W
    @product2 = products(:two)
    @product10 = products(:ten) # M128

    get api_v1_products_path, headers: { HTTP_AUTHORIZATION:
    "Token token=#{@token.token}" }, params: { model: "#{@product.model},#{@product10.model}" }
    json_response = JSON.parse(response.body)

    assert_equal json_response.size, 2
    assert json_response.include?(@product.as_json(include: :prices))
    assert_not json_response.include?(@product2.as_json(include: :prices))
  end
end
