class CroppingSystem < ActiveRecord::Base
  attr_accessible :crop, :grazing, :name, :state_id, :status, :tillage, :var12
  #Associatons
	has_many :events
  #validations
	 validates_uniqueness_of :var12
	 validates_presence_of :var12, :crop
  #scopes
     default_scope :order => "crop ASC"
end
