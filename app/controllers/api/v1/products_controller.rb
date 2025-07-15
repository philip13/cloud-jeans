require "csv"

class Api::V1::ProductsController < Api::V1::AuthenticatedController
  private

  DEFAULT_PRICE_TYPE = "PRECIO 1"
  ALLOWED_FILTERS = %w[brand cut model].freeze

  def setup_client
    @client = Client.find_by(phone: params[:phone]) if params[:phone].present?
  end

  def extract_filter_params
    ALLOWED_FILTERS.each_with_object({}) do |filter, hash|
      next unless params[filter].present?

      hash[filter] = params[filter].split(",").map { |w| w.upcase.strip }
    end
  end

  def client_price_type
    @client&.price_type || DEFAULT_PRICE_TYPE
  end

  public

  before_action :setup_client, only: [ :index ]

  def index
    begin
      filter_params = extract_filter_params

      if filter_params.any?
        products = ProductFilterService.new(filter_params, client_price_type).call
      else
        products = Product.include_price_type(DEFAULT_PRICE_TYPE)
      end

      render json: products.as_json(include: :prices), status: :ok
    rescue StandardError => e
      Rails.logger.error "Error fetching products: #{e.message}"
      render json: { error: "An error occurred while fetching products" }, status: :internal_server_error
    end
  end

  def cut_prise
    render json: CsvDataService.new("precios_tallas.csv").call, status: :ok
  end

  def size
    render json: CsvDataService.new("codigos_especificados.csv").call, status: :ok
  end
end
