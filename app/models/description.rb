class Description < ActiveRecord::Base
  attr_accessible :description, :detail, :unit, :spanish_description, :id, :position, :period, :order_id, :group_id
  #associations
	has_many :results
end
