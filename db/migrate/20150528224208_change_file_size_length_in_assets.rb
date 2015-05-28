class ChangeFileSizeLengthInAssets < ActiveRecord::Migration
  def change
    change_column :assets, :file_file_size, :integer, :limit => 8
  end
end
