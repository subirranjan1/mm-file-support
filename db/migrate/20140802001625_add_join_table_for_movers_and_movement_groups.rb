class AddJoinTableForMoversAndMovementGroups < ActiveRecord::Migration
  def change
    create_table :movement_groups_movers, id: false do |t|
      t.belongs_to :movement_group
      t.belongs_to :mover
    end    
  end
end
