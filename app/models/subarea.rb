class Subarea < ActiveRecord::Base
  attr_accessible :type, :description, :number, :inps, :iops, :iow, :ii, :iapl, :nvcn, :iwth, :ipts, :isao, :luns, :imw, 
    :sno, :stdo, :yct, :xct, :azm, :fl, :fw, :angl, :wsa, :chl, :chd, :chs, :chn, :slp, :splg, :upn, :ffpq, :urbf, :soil_id,
	:bmp_id, :scenario_id
  #associations
	  belongs_to :scenarios
	  belongs_to :soil
	  belongs_to :bmp
end
