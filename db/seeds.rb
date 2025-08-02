require 'csv'
require 'json'

# Product.destroy_all

# csv_path = Rails.root.join("app", "assets", "csv", "produc_brand_models.csv")
# csv_content = CSV.read(csv_path, headers: true)
# csv_content.each do |row|
#   row = row.to_hash
#   # pieces_per_package = row['Corte'].upcase == "COLOMBIANO" ? 12 : 24
#   # packaging_type = pieces_per_package == 24 ? "CAJA" : "PAQUETE"
#   pieces_per_package = row['Tipo de Paquete'] == "CAJA" ? 24 : 12
#   packaging_type = row["Tipo de Paquete"]

#   product = Product.new(
#     brand: row["Marca"].upcase,
#     cut: row["Corte"].upcase,
#     model: row["Modelo"].upcase,
#     quantity: 200,
#     quality: "PREMIUM",
#     description: "Descripton",
#     pieces_per_package: pieces_per_package,
#     packaging_type: packaging_type,
#     id_image: row["IdImage"]
#   )

#   precio1 = Price.new(price_type: "PRECIO 1", description: "1-5 unidades", value: 245)
#   precio2 = Price.new(price_type: "PRECIO 2", description: "6-10 unidades", value: 235)
#   precio3 = Price.new(price_type: "PRECIO 3", description: "11-15 unidades", value: 225)
#   precio4 = Price.new(price_type: "PRECIO 4", description: "16 o más unidades", value: 215)

#   product.prices = [ precio1, precio2, precio3, precio4 ]
#   product.save
#   puts "Product save? #{product.prices}"
# end

# N8nChatHistory.destroy_all

# chat_history_path = Rails.root.join("app", "assets", "csv", "N8nChatHistories.csv")
# chat_content = CSV.read(chat_history_path, headers: true)

# chat_content.each do |row|
#   session_id = row["session_id"]
#   message = row["message"]
#   created = row["created_at"]
#   chat = N8nChatHistory.create(
#     session_id: session_id,
#     message: JSON.parse(message),
#     created_at: created
#   )
#   puts "Chat => #{chat.inspect}"
# end
