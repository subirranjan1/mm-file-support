json.array!(@movement_groups) do |movement_group|
  json.extract! movement_group, :id, :name, :description, :public
  json.url movement_group_url(movement_group, format: :json)
  json.project_url project_url(movement_group.project, format: :json)
	json.owner_url user_url(movement_group.owner, format: :json)
	json.takes movement_group.takes do |json, take|
  	json.take_url take_url(take, format: :json)
	end
end
