class Field < ActiveRecord::Base
  attr_accessible :field_area, :field_average_slope, :field_name, :field_type, :location_id
  #Associations
  has_one :weather, :dependent => :destroy
end
