json.array!(@projects) do |project|
  json.extract! project, :id, :name, :description, :public
  json.url project_url(project, format: :json)
	json.owner_url user_url(project.owner, format: :json)
end