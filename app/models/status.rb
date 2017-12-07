class Status < ActiveRecord::Base
	attr_accessible :name

	default_scope {order("name ASC")}
end
