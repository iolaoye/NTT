class Chart < ActiveRecord::Base
  attr_accessible :description_id, :field_id, :month_year, :scenario_id, :soil_id, :value
end
