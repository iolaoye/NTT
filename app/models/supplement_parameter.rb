class SupplementParameter < ActiveRecord::Base
  attr_accessor :dmi_rheifers, :starting_julian_day, :ending_julian_day, :for_dmi_cows, :for_dmi_bulls, :for_dmi_calves,
  :for_dmi_heifers, :for_dmi_rheifers
  attr_accessible :code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :green_water_footprint, :scenario_id

    #associations
	  belongs_to :scenario

end
