class Watershed < ActiveRecord::Base
  attr_accessible :field_id, :name, :scenario_id
  #associations
	has_many :watersheds, :dependent => :destroy
    belongs_to :location
  #validations
    validates_uniqueness_of :name
end
