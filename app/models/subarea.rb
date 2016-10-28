class Subarea < ActiveRecord::Base
  attr_accessible :subarea_type, :description, :number, :inps, :iops, :iow, :ii, :iapl, :nvcn, :iwth, :ipts, :isao, :luns, :imw, 
    :sno, :stdo, :yct, :xct, :azm, :fl, :fw, :angl, :wsa, :chl, :chd, :chs, :chn, :slp, :splg, :upn, :ffpq, :urbf, :soil_id,
	:bmp_id, :scenario_id, :rchl, :rchd, :rcbw, :rctw, :rchs, :rchn, :rchc, :rchk, :rfpw, :rfpl, :rsee, :rsae, :rsve, :rsep, 
	:rsap, :rsvp, :rsv, :rsrr, :rsys, :rsyn, :rshc, :rsdp, :rsbd, :pcof, :bcof, :bffl, :nirr, :iri, :ira, :lm, :ifd, :idr, 
	:idf1, :idf2, :idf3, :idf4, :idf5, :bir, :efi, :vimx,:armn, :armx, :bft, :fnp4, :fmx, :drt, :fdsf, :pec, :dalg, :vlgn, 
	:coww, :ddlg, :solq, :sflg, :fnp2, :fnp5, :firg, :ny1, :ny2, :ny3,:ny4, :ny5, :ny6, :ny7, :ny8, :ny9, :ny10, :xtp1, :xtp2, 
	:xtp3, :xtp4, :xtp5, :xtp6, :xtp7, :xtp8, :xtp9, :xtp10
  #associations
	  belongs_to :scenario
	  belongs_to :soil
	  belongs_to :bmp
end
