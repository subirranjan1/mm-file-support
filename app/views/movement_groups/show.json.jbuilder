json.extract! @movement_group, :id, :name, :description, :created_at, :updated_at, :public
json.url movement_group_url(@movement_group, format: :json)
json.project_url project_url(@movement_group.project, format: :json)
json.owner_url user_url(@movement_group.owner, format: :json)