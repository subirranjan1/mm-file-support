class AddJoinTableForMoversAndDataTracks < ActiveRecord::Migration
  def change
    remove_reference :movers, :data_track, index: true
    
    create_table :data_tracks_movers, id: false do |t|
      t.belongs_to :data_track
      t.belongs_to :mover
    end
  end
end
