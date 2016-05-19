class ApexParameter < ActiveRecord::Base
  attr_accessible :parameter_id, :project_id, :value
  #associations
	belongs_to :project
	belongs_to :parameter
end
