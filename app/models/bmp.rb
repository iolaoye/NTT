class Bmp < ActiveRecord::Base
  attr_accessible :scenario_id, :bmp_id, :crop_id, :irrigation_id, :water_stress_factor, :irrigation_efficiency, :maximum_single_application, :safety_factor, :depth, 
	         :area, :number_of_animals, :days, :hours, :animal_id, :dry_manure, :no3_n, :po4_p, :org_n, :org_p, :width, :grass_field_portion, :buffer_slope_upland, :crop_width,
			 :slope_reduction, :sides, :bmpsublist_id
  #associations
     has_many :crops
	 has_many :subareas, :dependent => :destroy
     belongs_to :scenario
  #validations
	validates_uniqueness_of :bmpsublist_id, :scope => :scenario_id, :message => "already exist"
	validates :depth, numericality: { greater_than: 0 }, if: "bmpsublist_id == 3"
	validates :irrigation_efficiency, numericality: { greater_than: 0, less_than_or_equal_to: 1 }, if: "bmpsublist_id == 9 || bmpsublist_id == 1 || bmpsublist_id == 2"
    validates :slope_reduction, numericality: { greater_than: 0,  less_than_or_equal_to: 100 }, if: "bmpsublist_id == 16"
	validates :water_stress_factor, numericality: { greater_than: 0,  less_than_or_equal_to: 1 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2"
	validates :maximum_single_application, numericality: { greater_than: 0,  less_than: 100000 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2"
	validates :days, numericality: { greater_than: 0,  less_than_or_equal_to: 365 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2"
	validates :safety_factor, numericality: { greater_than: 0,  less_than_or_equal_to: 100000 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2 && irrigation_id == 7"
	validates :area, numericality: { greater_than: 0,  less_than_or_equal_to: 100000 }, if: "bmpsublist_id == 1 && irrigation_id == 8"
end
