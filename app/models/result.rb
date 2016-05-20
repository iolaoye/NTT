class Result < ActiveRecord::Base
  attr_accessible :field_id, :scenario_id, :soil_id, :value, :watershed_id, :description_id, :ci_value
  #associations
	  belongs_to :field
	  belongs_to :watershed
	  belongs_to :scenario
	  belongs_to :soil
	  belongs_to :description
  #scopes
	default_scope :order => "id ASC"
end
