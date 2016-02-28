class Weather < ActiveRecord::Base
  attr_accessible :field_id, :latitude, :longitude, :simulation_final_year, :simulation_initial_year, :station_id, :station_way
  #Associations
  has_one :station
  belongs_to :fields
end
