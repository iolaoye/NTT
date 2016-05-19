class Bmp < ActiveRecord::Base
  attr_accessible :scenario_id, :bmp_id, :crop_id, :irrigation_id, :water_stress_factor, :irrigation_efficiency, :maximum_single_application, :safety_factor, :depth, 
	         :area, :number_of_animals, :days, :hours, :animal_id, :dry_manure, :no3_n, :po4_p, :org_n, :org_p, :width, :grass_field_portion, :buffer_slope_upland, :crop_width,
			 :slope_reduction, :sides, :bmpsublist_id
  #associations
     has_many :crops
	 has_many :subareas, :dependent => :destroy
     belongs_to :scenario

     validates :water_stress_factor, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1 }
     validates :irrigation_efficiency, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1 }
     validates :days, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 365 }
     validates :maximum_single_application, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999 }
     validates :safety_factor, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999 }, :if => 'irrigation_id == 4'
     validates :area, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999 }, :if => 'irrigation_id == 5'
end
