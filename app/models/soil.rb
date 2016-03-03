class Soil < ActiveRecord::Base
  attr_accessible :albedo, :drainage_type, :field_id, :group, :key, :name, :percentage, :selected, :slope, :symbol
  #associations
     belongs_to :field
	 has_many :layers, :dependent => :destroy
end
