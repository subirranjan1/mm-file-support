class UpdateColumnNames < ActiveRecord::Migration
  def change
    # don't seem to be needed on deployed app? 
    rename_column :data_tracks, :movement_stream_id, :movement_group_id
    rename_column :movement_annotations, :movement_datum_id, :data_track_id
  end
end
