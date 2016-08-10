class Soil < ActiveRecord::Base
  attr_accessible :albedo, :drainage_type, :field_id, :group, :key, :name, :percentage, :selected, :slope, :symbol, :ffc, :wtmn, :wtmx, :wtbl, :gwst, :gwmx, :rft, :rfpk, :tsla, :xids, :rtn1, :xidk, :zqt, :zf, :ztk, :fbm, :fhp, :id, :created_at, :updated_at
  #associations
     belongs_to :field
	 has_many :layers, :dependent => :destroy
	 has_many :subareas, :dependent => :destroy
	 has_many :results, :dependent => :destroy
	 has_many :soil_operations, :dependent => :destroy
	 has_many :charts, :dependent => :destroy
  #validations
     validates_presence_of :key, :group, :name, :slope
     validates :slope, numericality: { greater_than: 0 }
  #scopes
    default_scope :order => "percentage DESC"
end
