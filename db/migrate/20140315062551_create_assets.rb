class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.references :attachable, polymorphic: true
      t.timestamps
    end
  end
end
