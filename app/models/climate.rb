class Climate < ActiveRecord::Base
  attr_accessible :bmp_id, :max_temp, :min_temp, :month, :precipitation, :spanish_month
end
