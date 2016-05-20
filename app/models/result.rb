class Result < ActiveRecord::Base
  attr_accessible :description, :detailed, :field_id, :scenario_id, :soil_id, :spanish_description, :units, :value, :watershed_id, :position, :ci_value
  #associations
	  belongs_to :field
	  belongs_to :watershed
	  belongs_to :scenario
	  belongs_to :soil
  #scopes
	default_scope :order => "position ASC"
end
