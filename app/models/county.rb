class County < ActiveRecord::Base
  attr_accessible :county_code, :county_name, :latitude, :longitude, :state_id, :status
  #Associatons
     belongs_to :state
  #validations
	 validates_uniqueness_of :name, :code
	 validates_presence_of :name, :code
end
