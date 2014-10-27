require 'bcrypt'
class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9\-.]/    
  VALID_PASSWORD_REGEX = /((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,20})/
  PASSWORD_REQUIREMENTS = "must: contain a digit from 0-9, one lowercase character, one uppercase character, one special symbol in the list '@#$%', and have a length of at least 6 characters and a maximum of 20 characters."
  # users.password_hash in the database is a :string
  include BCrypt
  # associations to indicate ownership
  has_many :owned_projects, class_name: "Project", foreign_key: "user_id"
  has_many :data_tracks
  has_many :movement_groups
  has_many :movement_annotations 
  # associations to indicate access granted
  has_many :owned_groups, class_name: "AccessGroup", foreign_key: "creator_id"
  has_and_belongs_to_many :access_groups
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "150x150>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/  
  
  
  attr_accessor :password # this is needed to use password and password confirmation virtually
  attr_accessor :password_confirmation
  # We need to validate that the user has typed the same password twice
  # but we only want to do the validation if they've opted to change their password.
  validates_confirmation_of :password, :if=>:should_validate_password?
  validates_presence_of :password_confirmation, if: :should_validate_password?
  before_save :hash_new_password, :if=>:should_validate_password?
  before_save { self.email = email.downcase }
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }, if: :email  
  validates :password, presence: true,
                       format: { with: VALID_PASSWORD_REGEX, message: PASSWORD_REQUIREMENTS }, if: :should_validate_password?
  before_create { generate_token(:auth_token) }
  
  def all_accessible_projects
    (owned_projects + accessible_projects).uniq
  end
  
  def authorized?(object)
    object.is_accessible_by? self
  end
  
  def display_name
    if self.alias.blank?
      return self.email
    else
      return self.alias
    end
  end
                         
  def authenticate(password)
    if BCrypt::Password.new(hashed_password).is_password? password
      return true
    end
    # If we get here it means either there's no user with that email, or the wrong
    # password was provided.  But we don't want to let an attacker know which. 
    return nil
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end  
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
    
  private
  # This is where the real work is done, store the BCrypt has in the
  # database
  
  def accessible_projects
    # access_groups.collect(&:projects).compact
    t = []
    access_groups.each do |group|
      group.projects.each do |project|
        t << project
      end
    end
    t
  end
  
  def hash_new_password
    self.hashed_password = BCrypt::Password.create(@password)
  end
  
  def should_validate_password?
    password_changed? or new_record?
  end
  # By default the form_helpers will set new_password to "",
  # we don't want to go saving this as a password
  def password_changed?
    !@password.blank?
  end  
  
end
