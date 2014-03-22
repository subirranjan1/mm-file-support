class RemoveRedundantNameFromAssets < ActiveRecord::Migration
  def change
    remove_column :assets, :name, :string
  end
end
