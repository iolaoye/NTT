class Parameter < ActiveRecord::Base
  attr_accessible :line, :number, :name, :description, :range_low, :range_high, :default_value, :id
end
