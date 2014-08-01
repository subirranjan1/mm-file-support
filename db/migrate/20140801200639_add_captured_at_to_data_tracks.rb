class AddCapturedAtToDataTracks < ActiveRecord::Migration
  def change
    add_column :data_tracks, :captured_at, :datetime
  end
end
