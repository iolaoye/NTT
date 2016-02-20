class Project < ActiveRecord::Base
  attr_accessible :description, :name
  #Associatons
    belongs_to :user
	has_one :location
  #validations
	 validates_uniqueness_of :name
	 validates_presence_of :name
end
