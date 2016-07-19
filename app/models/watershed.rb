class Watershed < ActiveRecord::Base
  attr_accessible :field_id, :name, :scenario_id
  #associations
	has_many :charts, :dependent => :destroy
    belongs_to :location
  #validations
    validates_uniqueness_of :name
    validates :name, length: { minimum: 1 }
end
