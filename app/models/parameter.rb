class Parameter < ActiveRecord::Base
  attr_accessible :line, :number, :name, :description, :range_low, :range_high, :default_value, :id

  #associations
	has_many :apex_parameters, :dependent => :destroy
end
