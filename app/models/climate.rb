class Climate < ActiveRecord::Base
  attr_accessible :bmp_id, :max_temp, :min_temp, :month, :precipitation, :spanish_month
  #associations
    belongs_to :bmp
  #validations 
     validates :month, uniqueness: { scope: :bmp_id }
     validates :precipitation, numericality: { greater_than_or_equal_to: 0 }
end
