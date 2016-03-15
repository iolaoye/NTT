class Bmpsublist < ActiveRecord::Base
  attr_accessible :name, :status, :bmplist_id
  #associations
     belongs_to :bmplist
     belongs_to :bmp
end
