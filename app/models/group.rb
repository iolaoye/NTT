class Group < ActiveRecord::Base
  attr_accessible :group_name, :spanish_group_name, :id
  #associations
	has_many :results
end
