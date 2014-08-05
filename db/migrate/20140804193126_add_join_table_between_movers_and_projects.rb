class AddJoinTableBetweenMoversAndProjects < ActiveRecord::Migration
  def change
    create_join_table :movers, :projects
  end
end
