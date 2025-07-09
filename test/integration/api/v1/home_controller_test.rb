require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home index without authentication" do
    get api_v1_home_index_path
    assert_response :unauthorized
    assert_equal "Unauthorized", JSON.parse(response.body)["message"]
  end

  test "home index valid authentication" do
    user = users(:one)
    token = user.api_tokens.create!

    get api_v1_home_index_path, headers: { HTTP_AUTHORIZATION: "Token token=#{token.token}" }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "Welcome to the API v1 home!", json_response["message"]
  end
end
