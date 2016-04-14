class Way < ActiveRecord::Base
  attr_accessible :way_name, :spanish_name, :way_value
  #associations
    belongs_to :weather
end
