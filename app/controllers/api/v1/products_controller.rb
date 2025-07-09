require "csv"

class Api::V1::ProductsController < Api::V1::AuthenticatedController
  def index
    begin
      unless product_params.blank?
        if product_params[:brand].present?
          brands = product_params[:brand].split(",").map(&:strip)
          products = Product.includes(:prices).where(brand: brands)
        end

        if product_params[:cut].present?
          cuts = product_params[:cut].split(",").map(&:strip)
          products = Product.includes(:prices).where(cut: cuts)
        end

        if product_params[:model].present?
          models = product_params[:model].split(",").map(&:strip)
          products = Product.includes(:prices).where(model: models)
        end

        json_data = products.as_json(include: :prices)
      else
        products = Product.includes(:prices).all
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
  def product_params
    params.permit(:brand, :cut, :model)
  end

  def get_information_from_csv(file_name)
    csv_path = Rails.root.join("app", "assets", "csv", file_name)
    csv_content = CSV.read(csv_path, headers: true)
    json_data = csv_content.map(&:to_h)
  end
end
