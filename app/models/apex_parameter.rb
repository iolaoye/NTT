class ApexParameter < ActiveRecord::Base
  attr_accessible :parameter_description_id, :project_id, :value
  #associations
	belongs_to :project
	belongs_to :parameter_description
end
