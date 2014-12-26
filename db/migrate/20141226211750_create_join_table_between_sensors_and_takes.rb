class CreateJoinTableBetweenSensorsAndTakes < ActiveRecord::Migration
  def change
      create_join_table :sensor_types, :takes
  end
end
