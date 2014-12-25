json.array!(@data_tracks) do |data_track|
  json.extract! data_track, :id, :name, :description, :public
	json.take_url take_url(data_track.take, format: :json)
	json.owner_url user_url(data_track.owner, format: :json)	
  json.url data_track_url(data_track, format: :json)
end
