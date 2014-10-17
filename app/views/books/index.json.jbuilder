json.array!(@books) do |book|
  json.extract! book, :id, :title, :description, :system, :isbn, :category, :ffg_sku, :slug
  json.url book_url(book, format: :json)
end
