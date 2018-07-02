class AplcatParameter < ActiveRecord::Base
  attr_accessible :abwc, :abwh, :abwmb, :adwgbc, :noc, :nomb, :norh, :prh, :adwgbh, :mrga, :jdcc, :gpc,
				 :tpwg, :csefa , :srop, :bwoc, :jdbs, :dmd, :dmi, :napanr, :napaip, :mpsm, :splm, :pmme, :rhaeba, :toaboba,
				 :vsim, :foue, :ash, :mmppfm, :cfmms, :fnemimms, :effn2ofmms, :dwawfga, :dwawflc, :dwawfmb, :pgu, :ada, :ape,
				 :platc, :pctbb, :ptdife, :tnggbc, :prb, :mm_type, :fmbmm, :abwrh, :nocrh, :abc, :forage_id, :jincrease, :stabilization, :decline, :opt4,
         :crude_low, :crude_high, :tdn_low, :tdn_high, :ndf_low, :ndf_high, :adf_low, :adf_high, :feed_low, :feed_high, :tripn, :freqtrip, :filedetails,
         :cattlepro, :purpose, :codepurpose, :mdogfc, :mxdogfc, :cwsoj, :cweoj, :ewc, :nodew, :byosm, :eyosm, :mrgauh, :plac, :pcbb, :domd,
         :faueea, :acim, :mmppm, :cffm, :fnemm, :effd, :ptbd, :pocib, :bneap, :cneap, :hneap, :pobw, :posw, :posb, :poad, :poada, :cibo, :drinkg,
         :drinkl, :drinkm, :avgtm, :avghm, :rhae, :tabo, :mpism, :spilm, :pom, :srinr, :sriip, :pogu, :adoa, :ape, :n_tfa, :n_sr, :n_arnfa, :n_arpfa,
         :n_nfar, :n_npfar, :n_co2enfa, :n_co2epfp, :n_co2enfp, :n_lamf, :n_lan2of, :n_laco2f, :n_socc, :i_tfa, :i_sr, :i_arnfa, :i_arpfa,
         :i_nfar, :i_npfar, :i_co2enfa, :i_co2epfp, :i_co2enfp, :i_lamf, :i_lan2of, :i_laco2f, :i_socc, :cpl_lowest, :cpl_highest, :tdn_lowest,
         :tdn_highest, :ndf_lowest, :ndf_highest, :adf_lowest, :adf_highest, :fir_lowest, :fir_highest, :theta, :fge, :fde, :first_area, :second_area,
         :third_area, :fourth_area, :fifth_area, :first_equip, :second_equip, :third_equip, :fourth_equip, :fifth_equip, :first_fuel, :second_fuel, :third_fuel,
         :fourth_fuel, :fifth_fuel, :trans_1, :categories_trans_1, :categories_slaug_1, :avg_marweight_1, :num_animal_1, :mortality_rate_1, :distance_1, :trailer_1, :trucks_1, :fuel_type_1,
         :same_vehicle_1, :loading_1, :carcass_1, :boneless_beef_1, :trans_2, :categories_trans_2, :categories_slaug_2, :avg_marweight_2, :num_animal_2,
         :mortality_rate_2, :distance_2, :trailer_2, :trucks_2, :fuel_type_2, :same_vehicle_2, :loading_2, :carcass_2, :boneless_beef_2, :trans_3,
         :categories_trans_3, :categories_slaug_3, :avg_marweight_3, :num_animal_3, :mortality_rate_3, :distance_3, :trailer_3, :trucks_3, :fuel_type_3,
         :same_vehicle_3, :loading_3, :carcass_3, :boneless_beef_3, :trans_4, :categories_trans_4, :categories_slaug_4, :avg_marweight_4, :num_animal_4,
         :mortality_rate_4, :distance_4, :trailer_4, :trucks_4, :fuel_type_4, :same_vehicle_4, :loading_4, :carcass_4, :boneless_beef_4

  #associations
	  belongs_to :scenario

  after_initialize do
	  if self.new_record?
		self.abwc = 1300
		self.noc = 100
		self.abwh =  900
		self.abwmb =  1500
		self.adwgbc = 1.7
		self.nomb = 8
		self.norh = 25
		self.prb =  20.0
		self.prh =  10.0
		self.adwgbh = 1.50
		self.mrga = 2.0
		self.jdcc = 142
		self.gpc = 283
		self.tpwg = 100
		self.csefa = 90
		self.srop = 80
		self.bwoc = 80
		self.jdbs = 274   #juliand day of buying/selling
		self.dmd = 80 #dry matter digestibility
		self.dmi = 2.3
		self.napanr = 0.61
		self.napaip = 1.235
		self.mpsm = 88.0
		self.splm = 5.0
		self.pmme = 40.0
		self.rhaeba = 95.0
		self.toaboba = 95.0
		self.vsim = 0.0
		self.foue = 0.04
		self.ash = 0.08
		self.mmppfm = 0.19
		self.cfmms = 1.5
		self.fnemimms = 1.0
		self.effn2ofmms = 0.02
		self.dwawfga = 0.033
		self.dwawflc = 0.015
		self.dwawfmb = 0.019
		self.pgu = 43.0
		self.ada = 100.0
		self.ape = 55.0
		self.platc = 67.0
		self.pctbb = 62.0
		self.ptdife = 11.15
		self.tnggbc = 5
		self.mm_type = 1
		self.fmbmm = 0.76
 	  end
  end
end
