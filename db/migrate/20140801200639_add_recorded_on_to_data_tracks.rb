class AddRecordedOnToDataTracks < ActiveRecord::Migration
  def change
    add_column :data_tracks, :recorded_on, :date
  end
end
