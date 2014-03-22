class Asset < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  has_attached_file :file
  #validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  # Validate content type
  #validates_attachment_content_type :avatar, :content_type => /\Aimage/
  # Validate filename
  #validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/]
  #must update before going live #TODO
  do_not_validate_attachment_file_type :file
end
