class Comment < ActiveRecord::Base
	attr_accessible :issue_id, :description

	default_scope {order("description ASC")}
end
