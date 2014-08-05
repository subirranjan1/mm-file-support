class Mover < ActiveRecord::Base
  has_and_belongs_to_many :data_tracks
  has_and_belongs_to_many :movement_groups
  has_and_belongs_to_many :movers  
  validates :name, presence: true
  validates :dob, presence: true
  validates :gender, presence: true  
  validates :expertise, presence: true  
  validates :public, presence: true  
end
