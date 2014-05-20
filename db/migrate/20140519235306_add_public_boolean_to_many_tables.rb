class AddPublicBooleanToManyTables < ActiveRecord::Migration
  def change
    add_column :movement_annotations, :public, :boolean, :default => false
    add_column :movement_groups, :public, :boolean, :default => false   
    add_column :projects, :public, :boolean, :default => false    
    add_column :data_tracks, :public, :boolean, :default => false
  end
end
