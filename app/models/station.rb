class Station < ActiveRecord::Base
  # attr_accessible :title, :body
  #Associations
  has_many :weathers
end
