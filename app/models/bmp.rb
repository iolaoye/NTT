class Bmp < ActiveRecord::Base
  attr_accessible :scenario_id, :bmp_id, :crop_id, :irrigation_id, :water_stress_factor, :irrigation_efficiency, :maximum_single_application, :safety_factor, :depth, 
	         :area, :number_of_animals, :days, :hours, :animal_id, :dry_manure, :no3_n, :po4_p, :org_n, :org_p, :width, :grass_field_portion, :buffer_slope_upland, :crop_width,
			 :slope_reduction, :sides, :bmpsublist_id
  #associations
     has_many :crops
	 has_many :subareas, :dependent => :destroy
     belongs_to :scenario
end
