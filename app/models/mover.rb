class Mover < ActiveRecord::Base
  has_and_belongs_to_many :data_track
  
  validates :name, presence: true
  validates :dob, presence: true
  validates :gender, presence: true  
  validates :expertise, presence: true  
  validates :public, presence: true  
end
