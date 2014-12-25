class CreateTakes < ActiveRecord::Migration
  def change
    create_table :takes do |t|
      t.string :name
      t.text :description
      t.references :movement_group, index: true
      t.boolean :public
      t.references :user, index: true

      t.timestamps
    end
  end
end
