class Bmplist < ActiveRecord::Base
  attr_accessible :name
  #associations
     has_many :bmpsublists, :dependent => :destroy
end
