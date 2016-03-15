class Field < ActiveRecord::Base
  attr_accessible :field_area, :field_average_slope, :field_name, :field_type, :location_id
  #Associations
    has_one :weather, :dependent => :delete
	belongs_to :location
	has_many :soils, :dependent => :delete_all
	has_many :scenarios, :dependent => :delete_all
end
