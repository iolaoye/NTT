class Control < ActiveRecord::Base
  attr_accessible :line, :column, :code, :name, :description, :range_low, :range_high, :default_value, :id
  #associations
	has_many :apex_controls, :dependent => :destroy
end
