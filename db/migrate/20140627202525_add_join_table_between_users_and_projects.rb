class AddJoinTableBetweenUsersAndProjects < ActiveRecord::Migration
  def change
    create_join_table :users, :projects        
  end
end
