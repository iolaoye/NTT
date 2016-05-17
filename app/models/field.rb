class Field < ActiveRecord::Base
  attr_accessible :field_area, :field_average_slope, :field_name, :field_type, :location_id
  #Associations
    has_one :weather, :dependent => :destroy
    has_one :site, :dependent => :destroy
	belongs_to :location
	has_many :soils, :dependent => :destroy
	has_many :scenarios, :dependent => :destroy
	has_many :results, :dependent => :destroy
  #validations
	 validates_uniqueness_of :field_name
	 validates_presence_of :field_name	
end
