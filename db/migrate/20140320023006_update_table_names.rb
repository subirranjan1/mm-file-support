class UpdateTableNames < ActiveRecord::Migration
  def change
    rename_table :movement_data, :data_tracks
    rename_table :movement_streams, :movement_groups
  end
end
