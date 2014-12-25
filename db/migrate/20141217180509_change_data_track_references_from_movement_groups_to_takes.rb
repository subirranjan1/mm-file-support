class ChangeDataTrackReferencesFromMovementGroupsToTakes < ActiveRecord::Migration
  def change
    remove_column :data_tracks, :movement_group_id
    add_column :data_tracks, :take_id, :integer
  end
end
