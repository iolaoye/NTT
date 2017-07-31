class CropSchedule < ActiveRecord::Base
  attr_accessible :class, :crop_schedule_id, :name, :state_id, :status
  self.primary_key = "crop_schedule_id"
  #scopes
	default_scope {order("name ASC")}
end
