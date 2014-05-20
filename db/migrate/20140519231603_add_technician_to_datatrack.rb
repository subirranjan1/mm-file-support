class AddTechnicianToDatatrack < ActiveRecord::Migration
  def change
    add_column :data_tracks, :technician, :string
  end
end
