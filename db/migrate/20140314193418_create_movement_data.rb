class CreateMovementData < ActiveRecord::Migration
  def change
    create_table :movement_data do |t|
      t.string :name
      t.string :description
      t.string :format
      t.belongs_to :movement_stream
      t.timestamps
    end
  end
end
