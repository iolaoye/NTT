class CroppingSystem < ActiveRecord::Base
  attr_accessible :crop, :grazing, :name, :state_id, :status, :tillage, :var12
end
