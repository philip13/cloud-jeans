require "csv"

class Api::V1::ProductsController < Api::V1::AuthenticatedController
  def cut_prise
    json_data = get_information_from_csv("precios_tallas.csv")
    render json: json_data, status: :ok
  end

  def size
    json_data = get_information_from_csv("codigos_especificados.csv")
    render json: json_data, status: :ok
  end

  private
  def get_information_from_csv(file_name)
    # Read the CSV file and convert it to JSON format
    csv_path = Rails.root.join("app", "assets", "csv", file_name)
    csv_content = CSV.read(csv_path, headers: true)
    json_data = csv_content.map(&:to_h)
  end
end
