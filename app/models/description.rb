class Description < ActiveRecord::Base
  attr_accessible :description, :detail, :unit, :spanish_description, :id, :position, :period
  #associations
	has_many :results

end
