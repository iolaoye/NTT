class AddColumnsToSubareaTable < ActiveRecord::Migration
  def change
    add_column :subareas, :soil_id, :integer
    add_column :subareas, :bmp_id, :integer
    add_column :subareas, :scenario_id, :integer
	#line 1
    add_column :subareas, :type, :string
    add_column :subareas, :description, :string
    add_column :subareas, :number, :integer
	#line 2
    add_column :subareas, :inps, :integer
    add_column :subareas, :iops, :integer
    add_column :subareas, :iow, :integer
    add_column :subareas, :ii, :integer
    add_column :subareas, :iapl, :integer
    add_column :subareas, :nvcn, :integer
    add_column :subareas, :iwth, :integer
	add_column :subareas, :ipts, :integer
    add_column :subareas, :isao, :integer
    add_column :subareas, :luns, :integer
    add_column :subareas, :imw, :integer
    #line 3
	add_column :subareas, :sno, :float
	add_column :subareas, :stdo, :float
	add_column :subareas, :yct, :float
	add_column :subareas, :xct, :float
	add_column :subareas, :azm, :float
	add_column :subareas, :fl, :float
	add_column :subareas, :fw, :float
	add_column :subareas, :angl, :float
	#line 4
	add_column :subareas, :wsa, :float
	add_column :subareas, :chl, :float
	add_column :subareas, :chd, :float
	add_column :subareas, :chs, :float
	add_column :subareas, :chn, :float
	add_column :subareas, :slp, :float
	add_column :subareas, :splg, :float
	add_column :subareas, :upn, :float
	add_column :subareas, :ffpq, :float
	add_column :subareas, :urbf, :float
	#line 5
	add_column :subareas, :rchl, :float
	add_column :subareas, :rchd, :float
	add_column :subareas, :rcbw, :float
	add_column :subareas, :rctw, :float
	add_column :subareas, :rchs, :float
	add_column :subareas, :rchn, :float
	add_column :subareas, :rchc, :float
	add_column :subareas, :rchk, :float
	add_column :subareas, :rfpw, :float
	add_column :subareas, :rfpl, :float
	#line 6
	add_column :subareas, :rsee, :float
	add_column :subareas, :rsae, :float
	add_column :subareas, :rsve, :float
	add_column :subareas, :rsep, :float
	add_column :subareas, :rsap, :float
	add_column :subareas, :rsvp, :float
	add_column :subareas, :rsv, :float
	add_column :subareas, :rsrr, :float
	add_column :subareas, :rsys, :float
	add_column :subareas, :rsyn, :float
	#line 7
	add_column :subareas, :rshc, :float
	add_column :subareas, :rsdp, :float
	add_column :subareas, :rsbd, :float
	add_column :subareas, :pcof, :float
	add_column :subareas, :bcof, :float
	add_column :subareas, :bffl, :float
	#line 8
    add_column :subareas, :nirr, :integer
    add_column :subareas, :iri, :integer
    add_column :subareas, :ira, :integer
    add_column :subareas, :lm, :integer
    add_column :subareas, :ifd, :integer
    add_column :subareas, :idr, :integer
    add_column :subareas, :idf1, :integer
    add_column :subareas, :idf2, :integer
    add_column :subareas, :idf3, :integer
    add_column :subareas, :idf4, :integer
    add_column :subareas, :idf5, :integer
	#line 9
	add_column :subareas, :bir, :float
	add_column :subareas, :efi, :float
	add_column :subareas, :vimx, :float
	add_column :subareas, :armn, :float
	add_column :subareas, :armx, :float
	add_column :subareas, :bft, :float
	add_column :subareas, :fnp4, :float
	add_column :subareas, :fmx, :float
	add_column :subareas, :drt, :float
	add_column :subareas, :fdsf, :float
	#line 10
	add_column :subareas, :pec, :float
	add_column :subareas, :dalg, :float
	add_column :subareas, :vlgn, :float
	add_column :subareas, :coww, :float
	add_column :subareas, :ddlg, :float
	add_column :subareas, :solq, :float
	add_column :subareas, :sflg, :float
	add_column :subareas, :fnp2, :float
	add_column :subareas, :fnp5, :float
	add_column :subareas, :firg, :float
	#line 11
	add_column :subareas, :ny1, :integer
	add_column :subareas, :ny2, :integer
	add_column :subareas, :ny3, :integer
	add_column :subareas, :ny4, :integer
	add_column :subareas, :ny5, :integer
	add_column :subareas, :ny6, :integer
	add_column :subareas, :ny7, :integer
	add_column :subareas, :ny8, :integer
	add_column :subareas, :ny9, :integer
	add_column :subareas, :ny10, :integer
	#line 12
	add_column :subareas, :xtp1, :integer
	add_column :subareas, :xtp2, :integer
	add_column :subareas, :xtp3, :integer
	add_column :subareas, :xtp4, :integer
	add_column :subareas, :xtp5, :integer
	add_column :subareas, :xtp6, :integer
	add_column :subareas, :xtp7, :integer
	add_column :subareas, :xtp8, :integer
	add_column :subareas, :xtp9, :integer
	add_column :subareas, :xtp10, :integer
  end
end
