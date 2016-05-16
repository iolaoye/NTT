class Operation < ActiveRecord::Base
  attr_accessible :amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :activity_id, :org_n, :org_p, :po4_p, :type_id, :year, :subtype_id
  #associations
  has_many :crops
  has_many :activities
  has_many :soil_operations, :dependent => :destroy
  belongs_to :scenario
  #scopes
     default_scope :order => "year, month_id, day, activity_id, id ASC"
end
