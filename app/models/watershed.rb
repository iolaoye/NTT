class Watershed < ActiveRecord::Base
  attr_accessible :field_id, :name, :scenario_id
  #associations
	has_many :charts, :dependent => :destroy
	has_many :watershed_scenarios, :dependent => :destroy
	has_many :results, :dependent => :destroy
    belongs_to :location
  #validations
    validates :name, length: { minimum: 1 }
    validates_uniqueness_of :name, :scope => :location_id
  #scopes
    default_scope :order => "name"
end
