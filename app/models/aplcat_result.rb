class AplcatResult < ActiveRecord::Base
  attr_accessible :month_id, :option_id, :calf_aws, :calf_dmi, :calf_gei, :calf_wi, :calf_sme, :calf_ni, :calf_tne, :calf_tnr, :calf_fne,
  :calf_une, :calf_eme, :calf_mme, :rh_aws, :rh_dmi, :rh_gei, :rh_wi, :rh_sme, :rh_ni, :rh_tne, :rh_tnr, :rh_fne, :rh_une, :rh_eme, :rh_mme,
  :fch_aws, :fch_dmi, :fch_gei, :fch_wi, :fch_sme, :fch_ni, :fch_tne, :fch_tnr, :fch_fne, :fch_une, :fch_eme, :fch_mme,
  :cow_aws, :cow_dmi, :cow_gei, :cow_wi, :cow_sme, :cow_ni, :cow_tne, :cow_tnr, :cow_fne, :cow_une, :cow_eme, :cow_mme,
  :bull_aws, :bull_dmi, :bull_gei, :bull_wi, :bull_sme, :bull_ni, :bull_tne, :bull_tnr, :bull_fne, :bull_une, :bull_eme, :bull_mme

  belongs_to :scenario

  after_initialize :init

  def init
  	self.cow_dmi ||= 0.0
  	self.cow_wi ||= 0.0
  	self.cow_eme ||= 0.0
  	self.cow_mme ||= 0.0
  	self.bull_dmi ||= 0.0
  	self.bull_wi ||= 0.0
  	self.bull_eme ||= 0.0
  	self.bull_mme ||= 0.0
  	self.calf_dmi ||= 0.0
  	self.calf_wi ||= 0.0
  	self.calf_eme ||= 0.0
  	self.calf_mme ||= 0.0  	
  	self.fch_dmi ||= 0.0
  	self.fch_wi ||= 0.0
  	self.fch_eme ||= 0.0
  	self.fch_mme ||= 0.0  	
  	self.rh_dmi ||= 0.0
  	self.rh_wi ||= 0.0
  	self.rh_eme ||= 0.0
  	self.rh_mme ||= 0.0  	
  end
end
