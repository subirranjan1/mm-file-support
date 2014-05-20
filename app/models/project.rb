class Project < ActiveRecord::Base
  has_many :movement_groups, dependent: :destroy
  belongs_to :owner, class_name: "User"

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  validates :name, presence: true
  validates :description, presence: true
end
