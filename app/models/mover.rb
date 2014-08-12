class Mover < ActiveRecord::Base
  has_and_belongs_to_many :data_tracks
  has_and_belongs_to_many :movement_groups
  has_and_belongs_to_many :projects 
  validates :name, presence: true
  # validates :dob, presence: true
  # validates :gender, presence: true  
  # validates :expertise, presence: true  
end
