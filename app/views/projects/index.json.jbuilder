json.array!(@projects) do |project|
  json.extract! project, :id, :name, :description, :public
  json.url project_url(project, format: :json)
	json.owner_url user_url(project.owner, format: :json)
	json.movement_groups project.movement_groups do |json, group|
  	json.url movement_group_url(group, format: :json)
	end
end