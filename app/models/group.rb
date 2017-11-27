class Group < ActiveRecord::Base
  attr_accessible :group_name, :group_name_spanish, :id
  #associations
	has_many :results
end
