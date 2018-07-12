class GrazingParameter < ActiveRecord::Base
  attr_accessible :code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :ending_julian_day, :green_water_footprint, :green_water_footprint_supplement,
      :starting_julian_day, :dmi_rheifers, :for_dmi_cows, :for_dmi_bulls, :for_dmi_heifers, :for_dmi_calves, :for_dmi_rheifers, :code_for, :for_button,
      :supplement_button

  #associations
	  belongs_to :scenario
  #validation
  validates :for_dmi_cows, numericality: { greater_than_or_equal_to: 1.0,  less_than_or_equal_to: 3.0 }, if: "for_button = 1"
  validates :for_dmi_cows, numericality: { greater_than_or_equal_to: 15.0,  less_than_or_equal_to: 30.0 }, if: "for_button = 2"
  validates :for_dmi_bulls, numericality: { greater_than_or_equal_to: 1.0,  less_than_or_equal_to: 3.5 }, if: "for_button = 1"
  validates :for_dmi_bulls, numericality: { greater_than_or_equal_to: 15.0,  less_than_or_equal_to: 35.0 }, if: "for_button = 2"
  validates :for_dmi_heifers, numericality: { greater_than_or_equal_to: 1.0,  less_than_or_equal_to: 3.0 }, if: "for_button = 1"
  validates :for_dmi_heifers, numericality: { greater_than_or_equal_to: 10.0,  less_than_or_equal_to: 25.0 }, if: "for_button = 2"
  validates :for_dmi_calves, numericality: { greater_than_or_equal_to: 1.0,  less_than_or_equal_to: 3.0 }, if: "for_button = 1"
  validates :for_dmi_calves, numericality: { greater_than_or_equal_to: 4.0,  less_than_or_equal_to: 20.0 }, if: "for_button = 2"
  validates :for_dmi_rheifers, numericality: { greater_than_or_equal_to: 1.0,  less_than_or_equal_to: 3.0 }, if: "for_button = 1"
  validates :for_dmi_rheifers, numericality: { greater_than_or_equal_to: 7.0,  less_than_or_equal_to: 25.0 }, if: "for_button = 2"
  validates :dmi_cows, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 1.0 }, if: "supplement_button = 1"
  validates :dmi_cows, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 10.0 }, if: "supplement_button = 2"
  validates :dmi_bulls, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 1.5 }, if: "supplement_button = 1"
  validates :dmi_bulls, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 15.0 }, if: "supplement_button = 2"
  validates :dmi_heifers, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 1.0 }, if: "supplement_button = 1"
  validates :dmi_heifers, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 10.0 }, if: "supplement_button = 2"
  validates :dmi_calves, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 1.0 }, if: "supplement_button = 1"
  validates :dmi_calves, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 5.0 }, if: "supplement_button = 2"
  validates :dmi_rheifers, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 1.0 }, if: "supplement_button = 1"
  validates :dmi_rheifers, numericality: { greater_than_or_equal_to: 0.1,  less_than_or_equal_to: 7.0 }, if: "supplement_button = 2"
end
