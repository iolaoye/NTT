class Comment < ApplicationRecord
  attr_accessible :name, :body, :post_id
  belongs_to :post
end
