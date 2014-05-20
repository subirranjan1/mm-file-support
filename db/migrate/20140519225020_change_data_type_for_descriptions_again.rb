class ChangeDataTypeForDescriptionsAgain < ActiveRecord::Migration
  def change
    change_column :data_tracks, :description, :text
    change_column :movement_annotations, :description, :text
    change_column :movement_groups, :description, :text     
    change_column :projects, :description, :text
  end
end
