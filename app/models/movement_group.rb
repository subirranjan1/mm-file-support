class MovementGroup < ActiveRecord::Base
  belongs_to :project
  has_many :data_tracks, dependent: :destroy
  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  belongs_to :owner, class_name: "User"
  
  validates :name, presence: true
  validates :project_id, presence: true
end
