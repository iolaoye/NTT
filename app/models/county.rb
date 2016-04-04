class County < ActiveRecord::Base
  attr_accessible :county_code, :county_name, :latitude, :longitude, :state_id, :status, :county_state_code
  #Associatons
     belongs_to :state
  #validations
	 validates_uniqueness_of :county_code
	 validates_presence_of :county_name, :county_code
  #scopes
     default_scope :order => "county_name ASC"

end
