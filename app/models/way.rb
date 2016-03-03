class Way < ActiveRecord::Base
  attr_accessible :way_name
  #associations
    belongs_to :weather
end
