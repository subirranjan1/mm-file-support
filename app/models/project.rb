class Project < ActiveRecord::Base
  has_many :movement_groups, dependent: :destroy
end
