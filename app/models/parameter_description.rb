class ParameterDescription < ActiveRecord::Base
  attr_accessible :parameter_desc_id, :line, :name, :number, :range_high, :range_low
  self.primary_key = "parameter_desc_id"
  #associations
	has_one :apex_control
end
