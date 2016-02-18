class Project < ActiveRecord::Base
  attr_accessible :description, :name
  #Associatons
    belongs_to :user
  #validations
	 validates_uniqueness_of :name
	 validates_presence_of :name
end
