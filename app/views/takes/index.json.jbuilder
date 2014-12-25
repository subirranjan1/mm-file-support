json.array!(@takes) do |take|
  json.extract! take, :id, :name, :description, :public
	json.movement_group_url movement_group_url(take.movement_group, format: :json)
	json.owner_url user_url(take.owner, format: :json)	
  json.url take_url(take, format: :json)
	json.data_tracks take.data_tracks do |json, track|
  	json.data_track_url data_track_url(track, format: :json)
	end
end
