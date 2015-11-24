json.array!(@posts) do |post|
  json.extract! post, :id, :autor, :title, :body
  json.url post_url(post, format: :json)
end
