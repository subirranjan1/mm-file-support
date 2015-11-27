class Project < ActiveRecord::Base
  has_many :movement_groups, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :movement_annotations, as: :attached
  has_and_belongs_to_many :access_groups #represents those with access priviledges
  has_and_belongs_to_many :movers, -> { distinct }
  has_and_belongs_to_many :sensor_types, -> { distinct } 
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  
  def is_accessible_by?(user)
    owner == user or user_in_access_groups? user
  end
  
  # provide a slightly nicer url for referencing individual items
  def to_param
    [id, name.parameterize].join("-")
  end
  
  # uses SQL like to determine if the name or preview text matches the search term
  def self.search(search)
    if search
      where("name like ? or description like ?", "%#{search}%", "%#{search}%") 
    else
      all
    end
  end
  
  # the superset of all data_tracks movers -- this is different from the projects' movers which are the defaults for new groups
  def all_movers
    m = []
    movement_groups.where(public: true).each do |group|
      group.takes.where(public: true).each do |take|
        take.data_tracks.where(public: true).each do |track|
          track.movers.each do |mover|
          m << mover
          end
        end
      end
    end
    m.uniq
  end
  
  # returns true if the project or any of its subsidiary components isn't true
  def any_not_public?
    return true unless self.public?
    movement_groups.each do |group|
      return true unless group.public?
      group.takes.each do |take|
        return true unless take.public?
        take.data_tracks.each do |track|
          return true unless track.public?
        end
      end
    end
    return false
  end
  
  #this sets the project and all subsidiary components to public==true
  def make_public
    unless self.public?
      self.public = true 
      self.save!
    end
    movement_groups.each do |group|
      group.make_public
    end
  end
  
  private
  
    def user_in_access_groups?(user)
      access_groups.each do |group|
        return true if group.users.include? user
      end
      return false
    end
end
