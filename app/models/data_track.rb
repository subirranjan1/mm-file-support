class DataTrack < ActiveRecord::Base
  belongs_to :movement_group
  has_one :asset, as: :attachable, dependent: :destroy
  has_many :movement_annotations
  has_and_belongs_to_many :movers
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  belongs_to :sensor_type
  belongs_to :owner, class_name: "User"
  
  validates :name, presence: true
  validates :movement_group_id, presence: true
  validates :sensor_type_id, presence: true
  
end
