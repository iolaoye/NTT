class Crop < ActiveRecord::Base
  attr_accessible :bushel_weight, :code, :conversion_factor, :dd, :dndc, :dry_matter, :dyam, :harvest_code, :heat_units, :itil, :lu_number, :name, :number, :plant_population_ac, :plant_population_ft, :plant_population_mt, :planting_code, :soil_group_a, :soil_group_b, :soil_group_c, :soil_group_d, :spanish_name, :state_id, :tb, :to1, :type, :yield_unit
  #scopes
	default_scope :order => "number ASC"
end