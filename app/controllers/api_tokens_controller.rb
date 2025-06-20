class ApiTokensController < ApplicationController
  before_action :authenticate_user!

  def index
    @api_tokens = current_user.api_tokens.order(created_at: :desc)
  end

  def create
    puts "Current user: #{current_user.inspect}"
    @api_token = current_user.api_tokens.create
    if @api_token.persisted?
      redirect_to api_tokens_path, notice: "API token created successfully."
    else
      redirect_to api_tokens_path, alert: "Failed to create API token."
    end
  end
end
