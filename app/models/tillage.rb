class Tillage < ActiveRecord::Base
  attr_accessible :abbreviation, :code, :dndc, :eqp, :name, :operation, :spanish_name, :status
  #associations
     belongs_to :activity
  #scopes
     default_scope {order("name ASC")}

end
