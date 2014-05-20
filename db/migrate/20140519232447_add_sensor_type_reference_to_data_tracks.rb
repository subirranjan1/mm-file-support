class AddSensorTypeReferenceToDataTracks < ActiveRecord::Migration
  def change
    add_reference :data_tracks, :sensor_type, index: true
  end
end
