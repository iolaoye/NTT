class Location < ActiveRecord::Base
  attr_accessible :county_id, :project_id, :state_id, :status
  #Associations
    has_one :state
	has_one :county
	has_many :fields, :dependent => :destroy
	has_many :watershed, :dependent => :destroy
	belongs_to :project
end
