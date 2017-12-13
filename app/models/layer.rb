class Layer < ActiveRecord::Base
  attr_accessible :bulk_density, :clay, :depth, :organic_matter, :ph, :sand, :silt, :soil_id, :soil_p, :uw, :fc, :wn, :smb, :woc, :cac, :cec, :rok, :cnds, :rsd, :bdd, :psp, :satc, :created_at, :updated_at
  #associations
    belongs_to :soil
  #scopes
    default_scope {order("depth ASC")}
  #validation
	validates_presence_of :sand
	validates_presence_of :silt
	validates_presence_of :depth
	validates_presence_of :clay
	validate :sum
  validates :depth, numericality: { greater_than: 0 }
  #Intialization
    after_initialize :init
  #Functions
  def init
    #will set the default value to 0.0 only if it's nil
    self.bulk_density  ||= 0.0
    self.clay  ||= 0.0
    self.depth  ||= 0.0
    self.organic_matter  ||= 0.0
    self.ph  ||= 0.0
    self.sand  ||= 0.0
    self.silt  ||= 0.0
    #self.soil_id  ||= 0.0     #WTF: soil_id should never be nil, this should never execute
    self.soil_p  ||= 0.0
    self.uw  ||= 0.0
    self.fc  ||= 0.0
    self.wn  ||= 0.0
    self.smb  ||= 0.0
    self.woc  ||= 0.0
    self.cac  ||= 0.0
    self.cec  ||= 0.0
    self.rok ||= 0.0
    self.cnds  ||= 0.0
    self.rsd  ||= 0.0
    self.bdd  ||= 0.0
    self.psp  ||= 0.0
    self.satc  ||= 0.0
  end

  def sum
    if !((self.sand.to_f + self.silt.to_f + self.clay.to_f) == 100)
      self.errors.add(:error, I18n.t('layer.sum'))
    end
  end
end
