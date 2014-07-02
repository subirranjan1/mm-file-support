class MovementGroup < ActiveRecord::Base
  belongs_to :project
  has_many :data_tracks, dependent: :destroy
  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  validates :name, presence: true
  validates :project_id, presence: true
  
  def is_accessible_by?(user)
    owner == user or project.users.include? user
  end
  
  def public_data_tracks
    data_tracks.where(public: true)
  end
end
