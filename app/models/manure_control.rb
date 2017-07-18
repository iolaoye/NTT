class ManureControl < ActiveRecord::Base
  attr_accessible :manure_control_id, :name, :no3n, :om, :orgn, :orgp, :po4p, :spanish_name
  self.primary_key = "manure_control_id"
end
