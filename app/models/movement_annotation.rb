class MovementAnnotation < ActiveRecord::Base
  has_one :asset, as: :attachable
  belongs_to :attached, polymorphic: true
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  validates :name, presence: true

  def is_accessible_by?(user)
    owner == user or attached.is_accessible_by?(user)
  end
end
