class CountyResult < ApplicationRecord
  attr_accessible :state_id, :county_id, :scenario_id, :year, :flow, :qdr, :surface_flow, :sed, :ymnu, :orgp, :po4, :orgn, :no3, :qdrn, :qdrp, :qn, :dprk, :irri, :pcp, :n2o, :prkn, :co2, :biom, :orgn_ci, :qn_ci, :no3_ci, :qdrn_ci, :po4_ci, :qdrp_ci, :surface_flow_ci, :flow_ci, :qdr_ci, :irri_ci, :dprk_ci, :sed_ci, :ymnu_ci, :co2_ci, :n2o_ci
  #associations
	  belongs_to :county
end