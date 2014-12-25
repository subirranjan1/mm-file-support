json.extract! @data_track, :id, :name, :description, :created_at, :updated_at, :technician, :public, :recorded_on
json.url data_track_url(@data_track, format: :json)
json.take_url take_url(@data_track.take, format: :json)
json.owner_url user_url(@data_track.owner, format: :json)
json.asset_url request.protocol + request.host_with_port + @data_track.asset.file.url