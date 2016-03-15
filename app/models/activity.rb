class Activity < ActiveRecord::Base
  attr_accessible :abbreviation, :apex_code, :code, :name, :spanish_name
  #associations
     has_many :tillages
  
end
