class SensorType < ActiveRecord::Base
  has_many :data_tracks
  
  validates :name, presence: true
#  validates :description, presence: true

  # provide a slightly nicer url for referencing individual items
  def to_param
    [id, name.parameterize].join("-")
  end
end
