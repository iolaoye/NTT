class Status < ActiveRecord::Base
	attr_accessible :user_id, :name

	default_scope {order("name ASC")}
end
