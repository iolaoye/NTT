class GrazingParameter < ActiveRecord::Base
  attr_accessor :forage, :dmi_rheifers
  attr_accessible :code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :ending_julian_day, :green_water_footprint, :starting_julian_day

  #associations
	  belongs_to :scenario
end
