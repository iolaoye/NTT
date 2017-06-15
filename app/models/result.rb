class Result < ActiveRecord::Base
  attr_accessible :watershed_id, :field_id, :soil_id, :scenario_id, :value, :ci_value, :description_id
  #associations
	  belongs_to :field
	  belongs_to :watershed
	  belongs_to :scenario
	  belongs_to :soil
	  belongs_to :description
	  belongs_to :crop
  #scopes
	default_scope :order => "description_id ASC"
end
