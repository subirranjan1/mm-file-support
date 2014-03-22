class CreateMovementAnnotations < ActiveRecord::Migration
  def change
    create_table :movement_annotations do |t|
      t.string :name
      t.string :description
      t.string :format
      t.belongs_to :movement_data
      t.timestamps
    end
  end
end
