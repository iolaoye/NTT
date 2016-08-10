class Project < ActiveRecord::Base
  attr_accessible :description, :name
  #Associatons
    belongs_to :user
	has_one :location, :dependent => :destroy
	has_many :apex_controls, :dependent => :destroy
	has_many :apex_parameters, :dependent => :destroy
  #validations
	 validates_uniqueness_of :name, :scope => user_id
	 validates_presence_of :name
end
