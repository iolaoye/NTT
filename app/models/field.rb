class Field < ActiveRecord::Base
  attr_accessible :field_area, :field_average_slope, :field_name, :field_type, :location_id
  #Associations
    has_one :weather, :dependent => :destroy
    has_one :site, :dependent => :destroy
	has_many :soils, :dependent => :destroy
	has_many :scenarios, :dependent => :destroy
	has_many :results, :dependent => :destroy
    has_many :charts, :dependent => :destroy
	belongs_to :location
  #validations
	 validates_uniqueness_of :location_id, :scope => :field_name
	 validates_presence_of :field_name, :field_area
     validates :field_area, numericality: { greater_than: 0 }
end
