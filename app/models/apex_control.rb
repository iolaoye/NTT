class ApexControl < ActiveRecord::Base
  attr_accessible :control_id, :value
  #associations
	belongs_to :project
	belongs_to :control
end
