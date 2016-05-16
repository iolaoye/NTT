class Irrigation < ActiveRecord::Base
  attr_accessible :name, :status, :code
  #associations
     belongs_to :bmp
end
