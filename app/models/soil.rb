class Soil < ActiveRecord::Base
  attr_accessible :albedo, :drainage_type, :field_id, :group, :key, :name, :percentage, :selected, :slope, :symbol, :ffc, :wtmn, :wtmx, :wtbl, :gwst, :gwmx, :rft, :rfpk, :tsla, :xids, :rtn1, :xidk, :zqt, :zf, :ztk, :fbm, :fhp
  #associations
     belongs_to :field
	 has_many :layers, :dependent => :destroy
	 has_many :subareas, :dependent => :destroy
	 has_many :results, :dependent => :destroy
	 has_many :soil_operations, :dependent => :destroy
  #scopes
    default_scope :order => "percentage DESC"
end
