class CropSchedule < ActiveRecord::Base
  attr_accessible :class, :self_id, :name, :state_id, :status
  self.primary_key = "self_id"
  #scopes
	default_scope {order("name ASC")}
end
