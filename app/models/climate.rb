class Climate < ActiveRecord::Base
  attr_accessible :bmp_id, :max_temp, :min_temp, :month, :precipitation, :spanish_month
  #associations
    belongs_to :bmp
  #validations 
     validates :month, uniqueness: { scope: :bmp_id }
end
