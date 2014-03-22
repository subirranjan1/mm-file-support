class DropRedundantDataTrackType < ActiveRecord::Migration
  def change
    remove_column :data_tracks, :format, :string
  end
end
