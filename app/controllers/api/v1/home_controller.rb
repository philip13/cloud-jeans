class Api::V1::HomeController < Api::V1::AuthenticatedController
  
  def index
    render json: { message: "Welcome to the API v1 home!" }
  end
end