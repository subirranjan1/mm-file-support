json.array!(@users) do |user|
  json.extract! user, :id, :email, :hashed_password
  json.url user_url(user, format: :json)
end
