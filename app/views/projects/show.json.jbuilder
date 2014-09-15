json.extract! @project, :id, :name, :description, :public, :created_at, :updated_at
json.owner_url user_url(@project.owner, format: :json)