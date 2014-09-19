class AddLicenseToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :license, :text
  end
end
