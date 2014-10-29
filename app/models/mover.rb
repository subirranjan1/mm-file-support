class Mover < ActiveRecord::Base
  has_and_belongs_to_many :data_tracks
  has_and_belongs_to_many :movement_groups
  has_and_belongs_to_many :projects 
  validates :name, presence: true
  # validates :dob, presence: true
  # validates :gender, presence: true  
  # validates :expertise, presence: true  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "150x150>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/  
end
