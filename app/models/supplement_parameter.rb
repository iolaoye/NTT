class SupplementParameter < ActiveRecord::Base
  attr_accessible :code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :green_water_footprint, :scenario_id

    #associations
	  belongs_to :scenario

end
