class AddAttachedToMovementAnnotation < ActiveRecord::Migration
  def change
    add_reference :movement_annotations, :attached, polymorphic: true, index: true
    remove_column :movement_annotations, :data_track_id
  end
end
