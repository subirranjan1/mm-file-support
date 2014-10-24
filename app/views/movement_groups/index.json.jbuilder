json.array!(@movement_groups) do |movement_group|
  json.extract! movement_group, :id, :name, :description, :public
  json.url movement_group_url(movement_group, format: :json)
  json.project_url project_url(movement_group.project, format: :json)
	json.owner_url user_url(movement_group.owner, format: :json)
	json.data_tracks movement_group.data_tracks do |json, track|
  	json.url data_track_url(track, format: :json)
	end
end
