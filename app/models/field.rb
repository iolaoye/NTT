class Field < ActiveRecord::Base
  attr_accessible :field_area, :field_average_slope, :field_name, :field_type, :location_id, :soilp, :soil_test
  #Associations
    has_one :weather, :dependent => :destroy
    has_one :site, :dependent => :destroy
	has_many :soils, :dependent => :destroy
	has_many :scenarios, :dependent => :destroy
	has_many :results, :dependent => :destroy
    has_many :charts, :dependent => :destroy
	has_many :watershed_scenarios, :dependent => :destroy
	has_many :annual_results, :through => :scenarios
	has_many :county_results, :through => :scenarios
	has_many :climes
	belongs_to :location
  #validations
	 validates_uniqueness_of :location_id, :scope => :field_name
	 validates_presence_of :field_name, :field_area
     validates :field_area, numericality: { greater_than: 0 }
end
