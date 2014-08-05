class CreateAccessGroups < ActiveRecord::Migration
  def change
    create_table :access_groups do |t|
      t.string      :name
      t.integer     :creator_id
      t.timestamps
    end
    #drop_table :projects_users
    create_join_table :access_groups, :projects
    create_join_table :access_groups, :users
  end
end
