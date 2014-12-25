class AddJoinTableBetweenMoversAndTakes < ActiveRecord::Migration
  def change
    create_join_table :movers, :takes
  end
end
