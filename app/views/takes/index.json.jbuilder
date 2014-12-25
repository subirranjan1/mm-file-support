json.array!(@takes) do |take|
  json.extract! take, :id, :name, :description, :MovementGroup_id, :public, :User_id
  json.url take_url(take, format: :json)
end
