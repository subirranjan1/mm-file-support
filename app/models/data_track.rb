require 'csv'
class DataTrack < ActiveRecord::Base
  belongs_to :movement_group
  has_one :asset, as: :attachable, dependent: :destroy
  has_many :movement_annotations
  has_and_belongs_to_many :movers
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  belongs_to :sensor_type
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  validates :name, presence: true
  validates :movement_group_id, presence: true
  validates :sensor_type_id, presence: true
  
  # uses SQL like to determine if the name or preview text matches the search term
  def self.search(search)
    if search
      where("name like ? or description like ?", "%#{search}%", "%#{search}%") 
    else
      all
    end
  end
    
  def is_accessible_by?(user)
    owner == user or movement_group.is_accessible_by? user
  end
  
  def self.import(file)
    CSV.foreach(file, headers: true, skip_blanks: true) do |row|
    
      owner = User.find_by_email(row['owner_email']) || User.create(email: row['owner_email'])
            
      project = Project.find_by_name(row['project_name']) || Project.create(name: row['project_name'])
      project.owner = owner
      project.description = row['project_description']
      mover_names = row['project_default_mover_names'].split(",")
      mover_names.each do |name|
        mover = Mover.find_by_name(name.strip) || Mover.new(name: name.strip)
        project.movers << mover
      end
      # sensor_names = row['project_default_sensor_names'].split(",")
      # sensor_names.each do |name|
      #   sensor = SensorType.find_by_name(name.strip) || Mover.new(name: name.strip)
      #   project.sensor_types << sensor
      # end
      project.save!

      take = MovementGroup.find_by_name(row['movement_group_name']) || MovementGroup.create(name: row['movement_group_name'])
      take.description = row['movement_group_description']
      take.project = project
      mover_names = row['movement_group_default_mover_names'].split(",")
      if mover_names.empty?
        take.movers = project.movers
      else
        mover_names.each do |name|
          mover = Mover.find_by_name(name.strip) || Mover.new(name: name.strip)
          take.movers << mover
        end
      end
      take.save!

      track = DataTrack.find_by_name(row['data_track_name']) || DataTrack.create(name: row['data_track_name'])
      track.description = row['data_track_description']
      track.technician = row['data_track_technician']
      mover_names = row['data_track_default_mover_names'].split(",")
      if mover_names.empty?
        track.movers = take.movers
      else
        mover_names.each do |name|
          mover = Mover.find_by_name(name.strip) || Mover.new(name: name.strip)
          track.movers << mover
        end
      end
      sensor_names = row['data_track_sensor_names'].split(",")
      sensor_names.each do |name|
        sensor = SensorType.find_by_name(name.strip) || SensorType.new(name: name.strip)
        sensor.sensor_types << sensor
      end
      
      unless row['data_track_filename'].blank? 
        asset = Asset.new(:file => row['data_track_filename'])
        asset.save!
        track.asset = asset
      end
            
      track.save!       

    end
  end
  
end
