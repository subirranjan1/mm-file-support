class Asset < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  has_attached_file :file, 
    :url => "/system/:class/:attachment/:id_partition/:basename_:style.:extension",
    :path => ':rails_root/public:url'
  #before_create :normalize_file_name
  #validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  # Validate content type
  #validates_attachment_content_type :avatar, :content_type => /\Aimage/
  # Validate filename
  #validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/]
  #must update before going live #TODO
  do_not_validate_attachment_file_type :file
  
  
private

  def normalize_file_name
    extension = File.extname(file_file_name).downcase
    base = ""
    if attachable.movement_group.exists?
      base = "#{attachable.movement_group.name}_#{base}"
      if attachable.movproject.exists?
        base = "#{attachable.movement_group.name}_#{base}"
      end
    end
    
    base = "#{project_name}_#{movement_group_name}_#{data_track_name}"
    self.file.instance_write(:file_name, "#{base}#{extension}")
  end
end
