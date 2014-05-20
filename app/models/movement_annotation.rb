class MovementAnnotation < ActiveRecord::Base
  has_one :asset, as: :attachable
  belongs_to :data_track
  belongs_to :owner, class_name: "User"  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  
  validates :name, presence: true
  validates :data_track_id, presence: true
end
