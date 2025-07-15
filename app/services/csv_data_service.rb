require "csv"
# Servicio para manejar datos CSV
class CsvDataService
  private

  def read_csv_data
    csv_path = Rails.root.join("app", "assets", "csv", @file_name)

    unless File.exist?(csv_path)
      raise "CSV file not found: #{@file_name}"
    end

    CSV.read(csv_path, headers: true).map(&:to_h)
  end

  def cache_key
    "csv_data_#{@file_name}_#{File.mtime(csv_path).to_i}"
  rescue
    "csv_data_#{@file_name}"
  end

  def csv_path
    @csv_path ||= Rails.root.join("app", "assets", "csv", @file_name)
  end

  public

  def initialize(file_name)
    @file_name = file_name
  end

  def call
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      read_csv_data
    end
  end
end
