class ParameterDescription < ActiveRecord::Base
  attr_accessible :id, :line, :name, :number, :range_high, :range_low
  #associations
	has_one :apex_control
end
