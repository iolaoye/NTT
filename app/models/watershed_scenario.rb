class WatershedScenario < ActiveRecord::Base
  attr_accessible :field_id, :scenario_id, :watershed_id 
    belongs_to :watershed
    belongs_to :field
    belongs_to :scenario
  #validations
    validates_uniqueness_of :field_id, :scope => :watershed_id
end
