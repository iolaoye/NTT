class Post < ApplicationRecord
	has_many :comments

	validates_uniqueness_of :title
end
