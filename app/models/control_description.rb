class ControlDescription < ActiveRecord::Base
  attr_accessible :code, :column, :control_desc_id, :line, :name, :range_high, :range_low
  self.primary_key = "control_desc_id"
  #associations
	has_one :apex_control
end
