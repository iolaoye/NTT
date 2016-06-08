class Watershed < ActiveRecord::Base
  attr_accessible :field_id, :name, :scenario_id
  #associations
    belongs_to :location
end
