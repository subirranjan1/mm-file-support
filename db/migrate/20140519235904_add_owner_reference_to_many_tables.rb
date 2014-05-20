class AddOwnerReferenceToManyTables < ActiveRecord::Migration
  def change
    add_reference :data_tracks, :user, index: true
    add_reference :movement_annotations, :user, index: true    
    add_reference :movement_groups, :user, index: true    
    add_reference :projects, :user, index: true    
  end
end
