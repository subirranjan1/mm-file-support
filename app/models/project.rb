class Project < ActiveRecord::Base
  has_many :movement_groups, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_and_belongs_to_many :users #represents those with access priviledges

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  
  def is_accessible_by?(user)
    owner == user or users.include? user
  end
  # uses SQL like to determine if the name or preview text matches the search term
  def self.search(search)
    if search
      where("name like ? or description like ? and public = ?", "%#{search}%", "%#{search}%", true) 
    else
      where(["public = ?", true])
    end
  end
end
