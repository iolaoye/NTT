class SupplementParameter < ActiveRecord::Base
  attr_accessible :code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :ending_julian_day, :green_water_footprint, :green_water_footprint_supplement,
      :starting_julian_day, :dmi_rheifers, :for_dmi_cows, :for_dmi_bulls, :for_dmi_heifers, :for_dmi_calves, :for_dmi_rheifers, :code_for, :for_button,
      :supplement_button

  #associations
	  belongs_to :scenario
  #validation
end
