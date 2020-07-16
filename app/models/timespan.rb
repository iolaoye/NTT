class Timespan < ApplicationRecord
	attr_accessible :bmp_id, :crop_id, :start_month, :start_day, :end_month, :end_day
  #associations
     belongs_to :bmp
end
