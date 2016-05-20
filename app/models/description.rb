class Description < ActiveRecord::Base
  attr_accessible :description, :detail, :unit, :spanish_description, :id
  #associations
	has_many :descriptions

end
