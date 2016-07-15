class Scenario < ActiveRecord::Base
  attr_accessible :name, :field_id
  #associations
	  has_many :operations, :dependent => :destroy
	  has_many :bmps, :dependent => :destroy
	  has_many :results, :dependent => :destroy
	  has_many :subareas, :dependent => :destroy
	  has_many :soil_operations, :dependent => :destroy
	  has_many :charts, :dependent => :destroy
	  belongs_to :field
  #validations
     validates_uniqueness_of :name, :scope => :field_id, :message => "already exist"
	 validates_presence_of :name
end
