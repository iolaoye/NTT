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
         :third_area, :fourth_area, :fifth_area, :first_equip, :second_equip, :third_equip, :fourth_equip, :fifth_equip, :first_fuel_id, :second_fuel_id, :third_fuel_id,
         :fourth_fuel_id, :fifth_fuel_id, :trans_1, :categories_trans_1, :categories_slaug_1, :avg_marweight_1, :num_animal_1, :mortality_rate_1, :distance_1, :trailer_1, :trucks_1, :fuel_type_1,
         :same_vehicle_1, :loading_1, :carcass_1, :boneless_beef_1, :trans_2, :categories_trans_2, :categories_slaug_2, :avg_marweight_2, :num_animal_2,
         :mortality_rate_2, :distance_2, :trailer_2, :trucks_2, :fuel_type_2, :same_vehicle_2, :loading_2, :carcass_2, :boneless_beef_2, :trans_3,
         :categories_trans_3, :categories_slaug_3, :avg_marweight_3, :num_animal_3, :mortality_rate_3, :distance_3, :trailer_3, :trucks_3, :fuel_type_3,
         :same_vehicle_3, :loading_3, :carcass_3, :boneless_beef_3, :trans_4, :categories_trans_4, :categories_slaug_4, :avg_marweight_4, :num_animal_4,
         :mortality_rate_4, :distance_4, :trailer_4, :trucks_4, :fuel_type_4, :same_vehicle_4, :loading_4, :carcass_4, :boneless_beef_4, :second_avg_marweight_1, :second_num_animal_1,
         :second_avg_marweight_2, :second_num_animal_2, :second_avg_marweight_3, :second_num_animal_3, :second_avg_marweight_4, :second_num_animal_4,
         :tjan, :tfeb, :tmar, :tapr, :tmay, :tjun, :tjul, :taug, :tsep, :toct, :tnov, :tdec, :hjan, :hfeb, :hmar, :hapr, :hmay, :hjun, :hjul, :haug, :hsep, :hoct, :hnov, :hdec,
         :adwgbc_agp, :adwgbh_agp, :jdcc_agp, :gpc_agp, :tpwg_agp, :csefa_agp, :srop_agp, :bwoc_agp, :jdbs_agp, :mm_type_amp, :fmbmm_amp, :vsim_gp, :ape_wpp,
         :sixth_area, :sixth_equip, :sixth_fuel_id, :seventh_area, :seventh_equip, :seventh_fuel_id, :eighth_area, :eighth_equip, :eighth_fuel_id,
         :ninth_area, :ninth_equip, :ninth_fuel_id, :tenth_area, :tenth_equip, :tenth_fuel_id, :eleventh_area, :eleventh_equip, :eleventh_fuel_id,
         :twelveth_area, :twelveth_equip, :twelveth_fuel_id, :thirteen_area, :thirteen_equip, :thirteen_fuel_id, :fourteen_area, :fourteen_equip, :fourteen_fuel_id,
         :fifteen_area, :fifteen_equip, :fifteen_fuel_id, :sixteen_area, :sixteen_equip, :sixteen_fuel_id, :seventeen_area, :seventeen_equip, :seventeen_fuel_id,
         :eighteen_area, :eighteen_equip, :eighteen_fuel_id, :ninteen_area, :ninteen_equip, :ninteen_fuel_id, :twenty_area, :twenty_equip, :twenty_fuel_id, :byos, :eyos, :number_of_forage,
         :running_drinking_water, :running_complete_stocker, :running_ghg, :running_transportation, :mm_type_but, :nit, :fqd, :uovfi, :srwc, :byos, :eyos, :forage

  #validations
  	validate :lowests
  #associations
	belongs_to :scenario

  	after_initialize do
	  	if self.new_record?
	  		#Grazing
	  		self.forage = false
		  	#1. animal parameters
			self.noc = 100
			self.nomb = 8
			self.norh = 25
	    	self.nocrh = 25
	    	self.prb =  20.0
			self.prh =  10.0
			self.abwc = 1300
			self.abwmb =  1500
			self.abwh =  900
			self.abwrh = 700
			self.adwgbc = 1.7
			self.adwgbh = 1.50
			self.jdcc = 142
			self.gpc = 283
			self.tpwg = 100
			self.csefa = 90
			self.srop = 80
			self.bwoc = 80
			self.jdbs = 27
	    	self.abc = 1
			self.mrga = 2.0
			#old variables not used right now.
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
			#2. CO2 Balance Input
			self.n_tfa = 1463
			self.n_sr = 4.68
			self.n_arnfa = 1463
			self.n_arpfa = 0
			self.n_nfar = 118.5
			self.n_npfar = 0
			self.n_co2enfp = 3.31
			self.n_co2enfa = 0
			self.n_co2epfp = 1.03
			self.n_lamf = -63
			self.n_lan2of = 1213
			self.n_laco2f = 0
			self.n_socc = -3600
			self.i_tfa = 1463
			self.i_sr = 4.68
			self.i_arnfa = 1463
			self.i_arpfa = 0
			self.i_nfar = 118.5
			self.i_npfar = 0
			self.i_co2enfp = 3.31
			self.i_co2enfa = 0
			self.i_co2epfp = 1.03
			self.i_lamf = -63
			self.i_lan2of = 1213
			self.i_laco2f = 0
			self.i_socc = -3600
			#3. Forage Quatilyt Input
			self.number_of_forage = 1
			self.forage_id = 127
			self.jincrease = 91
			self.stabilization = 105
			self.decline = 120
			self.opt4 = 134
			self.cpl_lowest = 3.3
			self.cpl_highest = 4.6
			self.tdn_lowest = 22
			self.tdn_highest = 90
			self.ndf_lowest = 0
			self.ndf_highest = 0
			self.adf_lowest = 2.0
			self.adf_highest = 5.5
			self.fir_lowest = 1.8
			self.fir_highest = 2.5
			#4. RunParm APLCAT Parameter
			self.running_drinking_water = 0
			self.running_complete_stocker = 0
			self.running_ghg = 0
			self.running_transportation = 0
			#5. Scenario File
			self.mdogfc = 283
			self.mxdogfc = 284
			self.cwsoj = 81
			self.cweoj = 83
			self.ewc = 1
			self.nodew = 7
			self.byosm = 2012
			self.eyosm = 2014
			#6. Secundary Emissions Input
			self.theta = 1
			self.fge = 1
			self.fde = 1
			self.first_area = 0
			self.first_equip = 0
			self.first_fuel_id = 1
      self.second_area = 0
			self.second_equip = 0
			self.second_fuel_id = 1
      self.third_area = 0
			self.third_equip = 0
			self.third_fuel_id = 1
      self.fourth_area = 0
			self.fourth_equip = 0
			self.fourth_fuel_id = 1
      self.fifth_area = 0
			self.fifth_equip = 0
			self.fifth_fuel_id = 1
      self.sixth_area = 0
			self.sixth_equip = 0
			self.sixth_fuel_id = 1
      self.seventh_area = 0
			self.seventh_equip = 0
			self.seventh_fuel_id = 1
      self.eighth_area = 0
			self.eighth_equip = 0
			self.eighth_fuel_id = 1
      self.ninth_area = 0
			self.ninth_equip = 0
			self.ninth_fuel_id = 1
      self.tenth_area = 0
			self.tenth_equip = 0
			self.tenth_fuel_id = 1
      self.eleventh_area = 0
			self.eleventh_equip = 0
			self.eleventh_fuel_id = 1
      self.twelveth_area = 0
			self.twelveth_equip = 0
			self.twelveth_fuel_id = 1
      self.thirteen_area = 0
			self.thirteen_equip = 0
			self.thirteen_fuel_id = 1
      self.fourteen_area = 0
			self.fourteen_equip = 0
			self.fourteen_fuel_id = 1
      self.fifteen_area = 0
			self.fifteen_equip = 0
			self.fifteen_fuel_id = 1
      self.sixteen_area = 0
			self.sixteen_equip = 0
			self.sixteen_fuel_id = 1
      self.seventeen_area = 0
			self.seventeen_equip = 0
			self.seventeen_fuel_id = 1
      self.eighteen_area = 0
			self.eighteen_equip = 0
			self.eighteen_fuel_id = 1
      self.ninteen_area = 0
			self.ninteen_equip = 0
			self.ninteen_fuel_id = 1
      self.twenty_area = 0
			self.twenty_equip = 0
			self.twenty_fuel_id = 1
			#7. Simulation Methods
			self.mm_type_but = 1
			self.nit = 1
			self.fqd = 1
			self.uovfi = 1
			self.srwc = 1
			self.byos = 2018
			self.eyos = 2019
			#8. Simulation Parameters
			self.mrgauh = 2.0
			self.plac = 62
			self.pcbb = 62
			self.fmbmm = 0.76
			self.domd = 87
			self.vsim = 1.5
			self.faueea = 0.04
			self.acim = 0.004
			self.mmppm = 0.17
			self.cffm = 0.5
			self.fnemm = 1.0
			self.effd = 0.01
			self.ptbd = 0.15
			self.pocib = 0.0
			self.bneap = 0.9
			self.cneap = 0.8
			self.hneap = 0.7
			self.pobw = 0.95
			self.posw = 0.956
			self.posb = 0.891
			self.poad = 0.8
			self.poada = 0.6
			self.cibo = 0.2
			#Water Estimation parameters
			self.drinkg = 0.033
			self.drinkl = 0.015
			self.drinkm = 0.019
			self.tjan = 42.0
			self.tfeb = 45.9
			self.tmar = 54.1
			self.tapr = 62.6
			self.tmay = 71.6
			self.tjun = 79.5
			self.tjul = 84.4
			self.taug = 84
			self.tsep = 75.7
			self.toct = 64.5
			self.tnov = 52.7
			self.tdec = 42.8
			self.hjan = 66.5
			self.hfeb = 66.0
			self.hmar = 62.5
			self.hapr = 63.0
			self.hmay = 68.5
			self.hjun = 66.5
			self.hjul = 60.5
			self.haug = 60.5
			self.hsep = 65.5
			self.hoct = 65.5
			self.hnov = 65.0
			self.hdec = 66.0
			self.rhae = 95
			self.tabo = 95
			self.mpism = 88
			self.spilm = 5
			self.pom = 40
			self.srinr = 0.078
			self.sriip = 0.214
			self.pogu = 100
			self.adoa = 46.8
			self.ape = 55
 	 	end
  	end

  	def lowests
  		if self.tdn_lowest > self.tdn_highest or self.tdn_lowest > 99 or self.tdn_lowest < 21 or self.tdn_highest  > 99 or self.tdn_highest < 21
  			self.errors.add(:error, I18n.t('aplcat.tdnlof'))
  		end
  		if self.cpl_lowest > self.cpl_highest
  			self.errors.add(:error, I18n.t('aplcat.cplof'))
  		end
  		if self.ndf_lowest > self.ndf_highest
  			self.errors.add(:error, I18n.t('aplcat.nlof'))
  		end
  		if self.adf_lowest > self.adf_highest
  			self.errors.add(:error, I18n.t('aplcat.alof'))
  		end
  		if self.fir_lowest > self.fir_highest
  			self.errors.add(:error, I18n.t('aplcat.firobw'))
  		end
  	end
end
