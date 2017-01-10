class Schedule < ActiveRecord::Base
  attr_accessible :activity_id, :apex_crop, :apex_fertilizer, :apex_operation, :apex_opv1, :apex_opv2, :crop_schedule_id, :day, :event_order, :id, :month, :year
end
