class Crop < ActiveRecord::Base
  attr_accessible :bushel_weight, :code, :conversion_factor, :dd, :dndc, :dry_matter, :dyam, :harvest_code, :heat_units, :itil, :lu_number, :name, :number, :plant_population_ac, :plant_population_ft, :plant_population_mt, :planting_code, :soil_group_a, :soil_group_b, :soil_group_c, :soil_group_d, :spanish_name, :state_id, :tb, :to1, :type, :yield_unit
  #scopes
	default_scope :order => "number ASC"

  def self.load_crops(state_id)
	cropping_systems = CroppingSystem.where(:state_id => state_id)
	crops = Array.new
	cropping_systems.each do |cs|
		events = Event.where(:cropping_system_id => cs.id)
		events.each do |e|
			crops.push(e.apex_crop) unless crops.include?(e.apex_crop)
		end # end each event
	end # end croping system 
	if I18n.locale.eql?(:en) then
		return self.select("id, name, type1").find_all_by_number(crops).sort_by(&:name)
	else
		return self.select("id, spanish_name as name, type1").find_all_by_number(crops).sort_by(&:name)
	end
  end #end load_crops method
end