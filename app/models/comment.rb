class Comment < ActiveRecord::Base
	attr_accessible :issue_id, :description
end
