class WatershedScenario < ActiveRecord::Base
  attr_accessible :field_id, :scenario_id, :watershed_id 
    belongs_to :watershed
  #validations
    validates_uniqueness_of :field_id
end
