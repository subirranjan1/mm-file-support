class AccessGroup < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :projects
  belongs_to :user, :foreign_key => :creator_id
end
