class Soil < ActiveRecord::Base
  attr_accessible :albedo, :drainage_id, :field_id, :group, :key, :name, :percentage, :selected, :slope, :symbol, :ffc, :wtmn, :wtmx, :wtbl, :gwst, :gwmx, :rft, :rfpk, :tsla, :xids, :rtn1, :xidk, :zqt, :zf, :ztk, :fbm, :fhp, :id, :created_at, :updated_at
  #associations
     belongs_to :field
	 has_many :layers, :dependent => :destroy
	 has_many :subareas, :dependent => :destroy
	 has_many :results, :dependent => :destroy
	 has_many :soil_operations, :dependent => :destroy
	 has_many :charts, :dependent => :destroy
  #validations
     validates_presence_of :key, :group, :name, :slope
     validates :albedo, numericality: { greater_than_or_equal_to: 0 }
     validates :slope, numericality: { greater_than: 0 }
     validates_format_of :group, :with => /\A([a-dA-d]\/[a-dA-d]{1}|[a-dA-d]{1})\z/
  #scopes
    default_scope { order("percentage DESC") }
end
