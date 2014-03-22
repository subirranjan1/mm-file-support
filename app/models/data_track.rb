class DataTrack < ActiveRecord::Base
  belongs_to :movement_group
  has_one :asset, as: :attachable, dependent: :destroy
  has_one :movement_annotation
  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
end
