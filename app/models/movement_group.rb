class MovementGroup < ActiveRecord::Base
  belongs_to :project
  has_many :data_tracks, dependent: :destroy
  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
end
