class MovementGroup < ActiveRecord::Base
  belongs_to :project
  has_many :data_tracks, dependent: :destroy
  has_and_belongs_to_many :movers, -> { distinct }
  has_and_belongs_to_many :sensor_types, -> { distinct }  
  has_many :movement_annotations, as: :attached  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  validates :name, presence: true
  validates :project_id, presence: true
  
  def is_accessible_by?(user)
    owner == user or project.is_accessible_by? user
  end
  
  def public_data_tracks
    data_tracks.where(public: true)
  end
  
  # provide a slightly nicer url for referencing individual items
  def to_param
    [id, name.parameterize].join("-")
  end
end
