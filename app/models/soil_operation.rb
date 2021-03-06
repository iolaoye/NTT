class SoilOperation < ActiveRecord::Base
  attr_accessible :apex_crop, :opv1, :opv2, :opv3, :opv4, :opv5, :opv6, :opv7, :activity_id, :id, :year, :month, :day, :operation_id, :type_id, :scenario_id, :soil_id, :apex_operation, :tractor_id
  #associations
	  belongs_to :operation
	  belongs_to :scenario
	  belongs_to :soil
	  belongs_to :bmp
  #scopes
    #default_scope {order("year, month, day, activity_id, type_id ASC")}
end
