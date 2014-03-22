json.array!(@data_tracks) do |data_track|
  json.extract! data_track, :id, :name, :description
  json.url data_track_url(data_track, format: :json)
end
