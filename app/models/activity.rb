class Activity < ActiveRecord::Base
  attr_accessible :abbreviation, :apex_code, :code, :name, :spanish_name, :amount_units, :amount_label, :depth_label, :depth_units
  #associations
     has_many :tillages
  
end
