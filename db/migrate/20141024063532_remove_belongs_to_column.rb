class RemoveBelongsToColumn < ActiveRecord::Migration
  def change
    remove_column :data_tracks, :sensor_type_id
  end
end
