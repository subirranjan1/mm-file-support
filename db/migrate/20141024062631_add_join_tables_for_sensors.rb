class AddJoinTablesForSensors < ActiveRecord::Migration
  def change
    create_join_table :sensor_types, :projects
    create_join_table :sensor_types, :movement_groups
    create_join_table :sensor_types, :data_tracks 
  end
end
