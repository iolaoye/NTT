class Bmplist < ActiveRecord::Base
  attr_accessible :name, :spanish_name
  #associations
     has_many :bmpsublists, :dependent => :destroy
end
