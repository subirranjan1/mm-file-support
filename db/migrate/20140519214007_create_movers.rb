class CreateMovers < ActiveRecord::Migration
  def change
    create_table :movers do |t|
      t.string :name
      t.date :dob
      t.string :gender
      t.string :expertise
      t.boolean :cma_like_training
      t.string :other_training
      t.belongs_to :data_track, index: true

      t.timestamps
    end
  end
end
