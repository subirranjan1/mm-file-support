require 'csv'
class DataTrack < ActiveRecord::Base
  belongs_to :take
  has_one :asset, as: :attachable, dependent: :destroy
  has_many :movement_annotations, as: :attached
  has_and_belongs_to_many :movers, -> { distinct }
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  has_and_belongs_to_many :sensor_types, -> { distinct }
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  validates :name, presence: true
  validates :take_id, presence: true
  
  # uses SQL like to determine if the name or preview text matches the search term
  def self.search(search)
    if search
      where("name like ? or description like ?", "%#{search}%", "%#{search}%") 
    else
      all
    end
  end
  
  # provide a slightly nicer url for referencing individual items
  def to_param
    [id, name.parameterize].join("-")
  end  
    
  def is_accessible_by?(user)
    return false if take.nil?
    owner == user or take.is_accessible_by? user
  end
  
  #TODO: Add takes
  def self.import(file)
    CSV.foreach(file, headers: true, skip_blanks: true) do |row|
      owner_email = row['owner_email']
      owner_email = "default-owner@movingstories.ca" if owner_email.blank?
      
      # unless they already exist, create the account and send them the email
      unless owner = User.find_by_email(owner_email)
        random_password = Array.new(10).map { (65 + rand(58)).chr }.join
        random_password += "1$" # stupid kludge to make it accepted by the acceptable password regex
        owner = User.create(email: row['owner_email'], password: random_password, password_confirmation: random_password)
        Mailer.forgot_password(owner, random_password).deliver
      end      
      project = Project.find_by_name(row['project_name']) || Project.new(name: row['project_name'])
      project.owner = owner
      project.description = row['project_description']
      mover_names = row['project_default_mover_names'].split(",") 
      project.save!      
      mover_names.each do |name|
        mover = Mover.find_by_name(name.strip) || Mover.new(name: name.strip)
        unless project.movers.include?(mover)
           project.movers << mover
        end
      end
      sensor_names = row['project_default_sensor_names'].split(",")
      sensor_names.each do |name|
        sensor = SensorType.find_by_name(name.strip) || Mover.new(name: name.strip)
        unless project.sensor_types.include?(sensor)
          project.sensor_types << sensor
        end        
      end

      group = MovementGroup.find_by_name(row['movement_group_name']) || MovementGroup.new(name: row['movement_group_name'])
      group.description = row['movement_group_desc']
      group.project = project
      group.owner = owner
      group.save!      
      mover_names = row['movement_group_default_mover_names'].split(",")
      if mover_names.empty?
        group.movers = project.movers
      else
        mover_names.each do |name|
          mover = Mover.find_by_name(name.strip) || Mover.new(name: name.strip)
          unless group.movers.include?(mover)
             group.movers << mover
          end          
        end
      end
      group.save!
      
      take = Take.find_by_name(row['movement_take_name']) || Take.new(name: row['movement_take_name'])
      take.description = row['movement_take_desc']
      take.movement_group = group
      take.owner = owner
      take.save!      
      mover_names = row['movement_take_default_mover_names'].split(",")
      if mover_names.empty?
        take.movers = project.movers
      else
        mover_names.each do |name|
          mover = Mover.find_by_name(name.strip) || Mover.new(name: name.strip)
          unless take.movers.include?(mover)
             take.movers << mover
          end          
        end
      end
      take.save!      
      
      # DataTrack.find_by_name(row['data_track_name']) || 
      track = DataTrack.find_by_name(row['data_track_name']) || DataTrack.create(name: row['data_track_name'])
      track.take = take
      track.owner = owner
      track.recorded_on = row['data_track_recorded_on']
      track.description = row['data_track_desc']
      track.technician = row['data_track_technician']
      track.save!       
      mover_names = row['data_track_mover_names'].split(",")
      if mover_names.empty?
        track.movers = take.movers
      else
        mover_names.each do |name|
          mover = Mover.find_by_name(name.strip) || Mover.new(name: name.strip)
          unless track.movers.include?(mover)
             track.movers << mover
          end          
        end
      end
      sensor_names = row['data_track_sensor_names'].split(",")
      sensor_names.each do |name|
        sensor = SensorType.find_by_name(name.strip) || SensorType.new(name: name.strip)
        unless track.sensor_types.include?(sensor)
          track.sensor_types << sensor
        end        
      end
      
      unless row['data_track_filename'].blank? 
        begin
          asset = Asset.new(:file => File.open(row['data_track_filename']))
          asset.attachable = track
          asset.save!
          track.asset = asset
        rescue
          puts "failed on #{row['data_track_filename']}"
        end
      end
      track.save!

    end
  end
  
end
