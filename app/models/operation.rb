class Operation < ActiveRecord::Base
  attr_accessible :amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :activity_id, :org_n, :org_p, :po4_p, :type_id, :year, :subtype_id, :moisture
  #associations
  has_many :crops
  has_many :activities
  has_many :soil_operations, :dependent => :destroy
  belongs_to :scenario
  #validations
    validates_uniqueness_of :crop_id, :scope => [:activity_id, :year, :month_id, :day, :type_id, :subtype_id]
    # sometimes these values are not needed
    #validates_presence_of :amount, :depth, :moisture, :nh3, :no3_n, :org_n, :org_p, :po4_p
  #scopes
     default_scope :order => "year, month_id, day, activity_id, id ASC"
end
