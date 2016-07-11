class Chart < ActiveRecord::Base
  attr_accessible :description_id, :field_id, :month_year, :scenario_id, :soil_id, :value
    #associations
	  belongs_to :scenario
	  belongs_to :soil
	  belongs_to :watershed
	  belongs_to :field
end
