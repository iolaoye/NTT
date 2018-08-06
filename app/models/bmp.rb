
class Bmp < ActiveRecord::Base
  attr_accessible :scenario_id, :bmp_id, :crop_id, :irrigation_id, :water_stress_factor, :irrigation_efficiency, :maximum_single_application, :safety_factor, :depth,
	         :area, :number_of_animals, :days, :hours, :animal_id, :dry_manure, :no3_n, :po4_p, :org_n, :org_p, :width, :grass_field_portion, :buffer_slope_upland, :crop_width,
			 :slope_reduction, :sides, :bmpsublist_id
  #associations
	  has_many :crops
	  has_many :subareas, :dependent => :destroy
	  has_many :climates, :dependent => :destroy
	  has_many :soil_operations, :dependent => :destroy
	  belongs_to :scenario
  #validations
    validates_uniqueness_of :bmpsublist_id, :scope => :scenario_id
    validates :water_stress_factor, numericality: { greater_than: 0,  less_than_or_equal_to: 1 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2"
    validates :irrigation_efficiency, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2 || bmpsublist_id == 9"
    validates :irrigation_id, numericality: { greater_than: 0 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2"
    validates :maximum_single_application, numericality: { greater_than: 0,  less_than: 100000 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2"
    validates :safety_factor, numericality: { greater_than_or_equal_to: 0,  less_than_or_equal_to: 100000 }, if: "irrigation_id == 7"
    validates :depth, numericality: { greater_than: 0 }, if: "bmpsublist_id == 3"
    validates :area, numericality: { greater_than: 0,  less_than_or_equal_to: 100000 }, if: "bmpsublist_id == 6 || bmpsublist_id == 7 || bmpsublist_id == 8 || bmpsublist_id == 12 || bmpsublist_id == 13 || bmpsublist_id == 23"
    #validates :number_of_animals, numericality: { greater_than: 0 }, if: "bmpsublist_id == 10"
    validates :days, numericality: { greater_than: 0,  less_than_or_equal_to: 365 }, if: "bmpsublist_id == 1 || bmpsublist_id == 2"
    #validates :depth, numericality: { greater_than: 0 }, if: "bmpsublist_id == 10"
    validates :width, numericality: { greater_than_or_equal_to: 0 }, if: "bmpsublist_id == 10"
    #validates :dry_manure, numericality: { greater_than: 0 }, if: "bmpsublist_id == 10"
    #validates :no3_n, numericality: { greater_than: 0, less_than: 1 }, if: "bmpsublist_id == 10"
    #validates :po4_p, numericality: { greater_than: 0, less_than: 1 }, if: "bmpsublist_id == 10"
    #validates :org_n, numericality: { greater_than: 0, less_than: 1 }, if: "bmpsublist_id == 10"
    #validates :org_p, numericality: { greater_than: 0, less_than: 1 }, if: "bmpsublist_id == 10"
  	validates :no3_n, numericality: { greater_than: 0, less_than: 100}, if: "bmpsublist_id == 18"
  	validates :po4_p, numericality: { greater_than: 0, less_than: 100}, if: "bmpsublist_id == 18"
  	validates :org_n, numericality: { greater_than: 0, less_than: 100}, if: "bmpsublist_id == 18"
  	validates :org_p, numericality: { greater_than: 0, less_than: 100}, if: "bmpsublist_id == 18"
    validates :width, numericality: { greater_than: 0 }, if: "bmpsublist_id == 4 || bmpsublist_id == 5 || bmpsublist_id == 6 || bmpsublist_id == 7 || bmpsublist_id == 14 || bmpsublist_id == 15 || bmpsublist_id == 23"
    validates :width, numericality: { greater_than: 0 }, if: "bmpsublist_id == 13 && depth == 13"
    validates :grass_field_portion, numericality: { greater_than: 0 }, if: "bmpsublist_id == 12"
    #validates :grass_field_portion, numericality: { greater_than_or_equal_to: 0.25, less_than_or_equal_to: 0.75 }, if: "bmpsublist_id == 13 && depth == 12"
    #validates :buffer_slope_upland, numericality: { greater_than_or_equal_to: 0.25, less_than_or_equal_to: 1.0 }, if: "bmpsublist_id == 12 || bmpsublist_id == 13 || bmpsublist_id == 23"
    validates :crop_width, numericality: { greater_than: 0 }, if: "bmpsublist_id == 15"
    validates :slope_reduction, numericality: { greater_than: 0,  less_than_or_equal_to: 100 }, if: "bmpsublist_id == 16"
    validates :sides, numericality: { greater_than: 0, less_than_or_equal_to: 4.0 }, if: "bmpsublist_id == 4 || bmpsublist_id == 5 || bmpsublist_id == 6 || bmpsublist_id == 7"
    #validates_uniqueness_of :bmp_id, :scope => :scenario_id, :message => "of this group already exists", if: "bmp_id == 1 || bmp_id == 8"
    #validates_uniqueness_of :bmp_id, :scope => :scenario_id, if: :pad_and_pipes_exists

  #Functions
  def pad_and_pipes_exists
    if bmpsublist_id == 4 || bmpsublist_id == 5 || bmpsublist_id == 6 || bmpsublist_id == 7
      sublist_ids = Array.wrap([4, 5, 6, 7])
      pads_exists = false
      sublist_ids.each do |sublist_id|
        if Bmp.find_by_bmpsublist_id(sublist_id) != nil
          pads_exists = true
        end #end if
      end #end each
	  end #end first if
	  return pads_exists
  end #end function

  def delete_records
    self.soil_operations.delete_all
    self.climates.delete_all
    self.delete
  end
end
