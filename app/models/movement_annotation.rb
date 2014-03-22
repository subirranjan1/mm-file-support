class MovementAnnotation < ActiveRecord::Base
  has_one :asset, as: :attachable
  belongs_to :movement_datum
  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
end
