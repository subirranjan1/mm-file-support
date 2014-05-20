class SensorType < ActiveRecord::Base
  has_many :data_tracks
  
  validates :name, presence: true
  validates :description, presence: true
end
