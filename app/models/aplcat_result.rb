class AplcatResult < ActiveRecord::Base
  attr_accessible :month_id, :option_id, :calf_aws, :calf_dmi, :calf_gei, :calf_wi, :calf_sme, :calf_ni, :calf_tne, :calf_tnr, :calf_fne,
  :calf_une, :calf_eme, :calf_mme, :rh_aws, :rh_dmi, :rh_gei, :rh_wi, :rh_sme, :rh_ni, :rh_tne, :rh_tnr, :rh_fne, :rh_une, :rh_eme, :rh_mme,
  :fch_aws, :fch_dmi, :fch_gei, :fch_wi, :fch_sme, :fch_ni, :fch_tne, :fch_tnr, :fch_fne, :fch_une, :fch_eme, :fch_mme,
  :cow_aws, :cow_dmi, :cow_gei, :cow_wi, :cow_sme, :cow_ni, :cow_tne, :cow_tnr, :cow_fne, :cow_une, :cow_eme, :cow_mme,
  :bull_aws, :bull_dmi, :bull_gei, :bull_wi, :bull_sme, :bull_ni, :bull_tne, :bull_tnr, :bull_fne, :bull_une, :bull_eme, :bull_mme
  
end
