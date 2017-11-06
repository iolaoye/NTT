class Operation < ActiveRecord::Base
  attr_accessible :amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :activity_id, :org_n, :org_p, :po4_p, :type_id, :year, :subtype_id, :moisture, :scenario_id, :org_c, :nh4_n
  #associations
  has_many :crops
  has_many :activities
  has_many :soil_operations, :dependent => :destroy
  belongs_to :scenario
  #validations
  validates_uniqueness_of :scenario_id, :scope => [:crop_id, :activity_id, :year, :month_id, :day, :type_id, :subtype_id, :amount, :depth, :org_n, :org_p, :po4_p, :no3_n, :org_c, :nh4_n] 
  # sometimes these values are not needed
  #validates_presence_of :amount, :depth, :moisture, :nh3, :no3_n, :org_n, :org_p, :po4_p
	validate :sum
  validates :amount, numericality: { greater_than: 0 }, if: "activity_id == 2"
  default_scope {order("activity_id, year, month_id, day, id ASC")}
  #Functions
  def sum
    if self.activity_id == 2 || self.activity_id == 7
	  if !((self.no3_n.to_f + self.po4_p.to_f + self.org_n.to_f + self.org_p.to_f) <= 100)
		  self.errors.add(:error, I18n.t('operation.sum'))
      end
    end
  end

  def type_name
    case self.activity_id
      when 1
        Tillage.find_by_code(self.type_id).eqp
      when 2
        Fertilizer.find(self.subtype_id).name
      when 3
        Tillage.find_by_code(self.type_id).eqp
      when 6
        Irrigation.find(self.type_id).name
      when 7
        Fertilizer.find(self.type_id).name
      else
        ""
    end
  end
  
end
