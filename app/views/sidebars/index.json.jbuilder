json.array!(@sidebars) do |sidebar|
  json.extract! sidebar, :id, :title, :content, :slug
  json.url sidebar_url(sidebar, format: :json)
end
