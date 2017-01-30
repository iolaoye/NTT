class GrazingParameter < ActiveRecord::Base
  attr_accessible :code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :ending_julian_day, :green_water_footprint, :starting_julian_day
end
