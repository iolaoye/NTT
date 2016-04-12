class Bmpsublist < ActiveRecord::Base
  attr_accessible :name, :status, :bmplist_id, :spanish_name
  #associations
     belongs_to :bmplist
     belongs_to :bmp
end
