require "csv"

class Api::V1::ProductsController < Api::V1::AuthenticatedController
  before_action :setup_client, only: [ :index ]

  def index
    begin
      if params[:brand].present? || params[:cut].present? || params[:model].present? || params[:phone].present?
        price_type = @client.nil? ? "PRECIO 1" : @client.price_type

        if params[:brand].present?
          brands = params[:brand].split(",").map(&:strip)
          products = Product.includes(:prices).where(brand: brands)
        end

        if params[:cut].present?
          cuts = params[:cut].split(",").map(&:strip)
          products = Product.includes(:prices).where(cut: cuts)
        end

        if params[:model].present?
          models = params[:model].split(",").map(&:strip)
          products = Product.includes(:prices).where(model: models)
        end

        products = products.nil? ?
          Product.include_price_type(price_type) :
          products.include_price_type(price_type)

        json_data = products.as_json(include: :prices)
      else
        products = Product.include_price_type("PRECIO 1")
        json_data = products.as_json(include: :prices)
      end
      render json: json_data, status: :ok
    rescue => e
      render json: { error: "An error occurred while fetching products: #{e.message}" }, status: :internal_server_error
    end
  end

  def cut_prise
    json_data = get_information_from_csv("precios_tallas.csv")
    render json: json_data, status: :ok
  end

  def size
    json_data = get_information_from_csv("codigos_especificados.csv")
    render json: json_data, status: :ok
  end

  private
  def setup_client
    @client = Client.find_by(phone: params[:phone])
  end

  def get_information_from_csv(file_name)
    csv_path = Rails.root.join("app", "assets", "csv", file_name)
    csv_content = CSV.read(csv_path, headers: true)
    json_data = csv_content.map(&:to_h)
  end
end
