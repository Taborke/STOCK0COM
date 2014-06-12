json.array!(@users) do |user|
  json.extract! user, :id, :email, :login
  json.url user_url(user, format: :json)
end
