class Weather < ActiveRecord::Base
  attr_accessible :field_id, :latitude, :longitude, :simulation_final_year, :simulation_initial_year, :station_id, :station_way, :weather_file, :way_id, :weather_final_year, :weather_initial_year
  #Associations
  has_one :way
  has_one :station
  belongs_to :field
  #Validations
  validate :simulation_years
  #Functions
  def simulation_years
    if self.simulation_final_year < self.simulation_initial_year
      self.errors.add(:simulation_final_year, I18n.t('weather.simulation_only_error'))
    end
    if self.simulation_final_year > self.weather_final_year
      self.errors.add(:simulation_final_year, I18n.t('weather.final_simulation_error') + ": " + self.weather_final_year.to_s)
    end
    if self.simulation_initial_year < self.weather_initial_year + 5
      self.errors.add(:simulation_initial_year, I18n.t('weather.initial_simulation_error') + ": " + (self.weather_initial_year + 5).to_s)
    end
  end
end
