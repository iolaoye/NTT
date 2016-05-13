class SoilOperation < ActiveRecord::Base
  attr_accessible :crop_id
  #associations
	  belongs_to :operation
end
