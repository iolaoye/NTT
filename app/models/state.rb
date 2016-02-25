class State < ActiveRecord::Base
  attr_accessible :state_code, :state_name, :status
  #Associatons
    belongs_to :location
	has_many :counties
  #validations
	 validates_uniqueness_of :state_name, :state_code
	 validates_presence_of :state_name, :state_code
end
