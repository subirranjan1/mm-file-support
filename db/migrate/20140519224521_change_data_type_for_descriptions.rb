class ChangeDataTypeForDescriptions < ActiveRecord::Migration
  def change
    change_column :data_tracks, :description, :string
    change_column :movement_annotations, :description, :string    
    change_column :movement_groups, :description, :string        
    add_column :projects, :description, :string
  end
end
