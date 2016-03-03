class Station < ActiveRecord::Base
  # attr_accessible :title, :body
  #Associations
    belongs_to :weather
end
