class Irrigation < ActiveRecord::Base
  attr_accessible :name, :status
  #associations
     belongs_to :bmp
end
