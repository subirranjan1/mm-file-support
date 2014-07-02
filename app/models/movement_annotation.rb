class MovementAnnotation < ActiveRecord::Base
  has_one :asset, as: :attachable
  belongs_to :data_track
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  validates :name, presence: true
  validates :data_track_id, presence: true

  def is_accessible_by?(user)
    owner == user or data_track.movement_group.project.users.include? user
  end
end
