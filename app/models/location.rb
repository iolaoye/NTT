class Location < ActiveRecord::Base
  attr_accessible :county_id, :project_id, :state_id, :status
  #Associations
    has_one :state
	has_one :county
	belongs_to :project
end
