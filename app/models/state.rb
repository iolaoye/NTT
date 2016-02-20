class State < ActiveRecord::Base
  attr_accessible :state_code, :state_name, :status
  #Associatons
    belongs_to :location
	has_many :counties
  #validations
	 validates_uniqueness_of :name, :code
	 validates_presence_of :name, :code
end
