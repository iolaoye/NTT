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
         :tdn_highest, :ndf_lowest, :ndf_highest, :adf_lowest, :adf_highest, :fir_lowest, :fir_highest

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
