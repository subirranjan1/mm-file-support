class AddAttachmentAvatarToMovers < ActiveRecord::Migration
  def self.up
    change_table :movers do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :movers, :avatar
  end
end
