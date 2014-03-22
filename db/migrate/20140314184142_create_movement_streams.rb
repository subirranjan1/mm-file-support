class CreateMovementStreams < ActiveRecord::Migration
  def change
    create_table :movement_streams do |t|
      t.string :name
      t.string :description
      t.belongs_to :project
      t.timestamps
    end
  end
end
