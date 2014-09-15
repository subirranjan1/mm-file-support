json.extract! @data_track, :id, :name, :description, :created_at, :updated_at, :technician, :public, :recorded_on
json.url data_track_url(@data_track, format: :json)
json.movement_group_url movement_group_url(@data_track.movement_group, format: :json)
json.owner_url user_url(@data_track.owner, format: :json)
json.sensor_url sensor_type_url(@data_track.sensor_type, format: :json)
json.asset_url user_url(@data_track.asset, format: :json) 