class Take < ActiveRecord::Base
  belongs_to :movement_group
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :data_tracks, dependent: :destroy
  has_and_belongs_to_many :movers, -> { distinct }
  has_and_belongs_to_many :sensor_types, -> { distinct }  
  has_many :movement_annotations, as: :attached  
  acts_as_taggable # Alias for acts_as_taggable_on :tags
    
  validates :name, presence: true
  validates :movement_group_id, presence: true

  def is_accessible_by?(user)
    owner == user or movement_group.is_accessible_by? user
  end

  def public_data_tracks
    data_tracks.where(public: true)
  end
  
  def make_public
    unless self.public?
      self.public = true 
      self.save!
    end
  end
  
  # provide a slightly nicer url for referencing individual items
  def to_param
    [id, name.parameterize].join("-")
  end  
end

