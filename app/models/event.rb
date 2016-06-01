class Event < ActiveRecord::Base
  attr_accessible :apex_crop, :apex_fertilizer, :apex_operation, :apex_opv1, :apex_opv2, :day, :event_order, :activity_id, :month, :year
  #Associatons
     belongs_to :cropping_system
  #scopes
     default_scope :order => "year, month, day, event_order  ASC"
end
