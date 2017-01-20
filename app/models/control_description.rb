class ControlDescription < ActiveRecord::Base
  attr_accessible :code, :column, :id, :line, :name, :range_high, :range_low
  #associations
	has_one :apex_control
end
