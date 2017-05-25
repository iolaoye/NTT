class CropSchedule < ActiveRecord::Base
  attr_accessible :class, :id, :name, :state_id, :status
  #scopes
	default_scope :order => "name ASC"
end
