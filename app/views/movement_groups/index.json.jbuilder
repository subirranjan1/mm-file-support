json.array!(@movement_groups) do |movement_stream|
  json.extract! movement_group, :id, :name, :description
  json.url movement_group_url(movement_group, format: :json)
end
