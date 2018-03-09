class CreateAplcatParameters < ActiveRecord::Migration
  def change
    create_table :aplcat_parameters do |t|
      t.integer :aplcat_param_id
	  t.integer :scenario_id
      t.integer :noc
      t.integer :nomb
      t.integer :norh
      t.float :abwc
      t.float :abwmb
      t.float :abwh
      t.float :prh
      t.float :prb
      t.float :adwgbc
      t.float :adwgbh
	  t.float :mrga
	  t.integer :jdcc
	  t.integer :gpc
	  t.float :tpwg
	  t.integer :csefa
	  t.float :srop
	  t.float :bwoc
	  t.integer :jdbs
	  t.float :dmd
	  t.float :dmi
	  t.float :napanr
	  t.float :napaip
	  t.float :mpsm
	  t.float :splm
	  t.float :pmme
	  t.float :rhaeba
	  t.float :toaboba
	  t.float :vsim
	  t.float :foue
	  t.float :ash
	  t.float :mmppfm
	  t.float :cfmms
	  t.float :fnemimms
	  t.float :effn2ofmms
	  t.float :dwawfga
	  t.float :dwawflc
	  t.float :dwawfmb
	  t.float :pgu
	  t.float :ada
	  t.float :ape
	  t.float :platc
	  t.float :pctbb
	  t.float :ptdife
	  t.integer :tnggbc
    t.float :mrgauh
    t.float :abwrh
    t.integer :nocrh
    t.integer :abc
    t.float :pcbb
    t.float :fmbmm
    t.float :domd
    t.float :vsim
    t.float :faueea
    t.float :acim
    t.float :mmppm
    t.float :cffm
    t.float :fnemm
    t.float :effd
    t.float :ptbd
    t.float :pocib
    t.float :bneap
    t.float :cneap
    t.float :hneap
    t.float :pobw
    t.float :posw
    t.float :posb
    t.float :poad
    t.float :poada
    t.float :cibo
    t.integer :mm_type
    t.integer :nit
    t.integer :fqd
    t.integer :uovfi
    t.integer :srwc

      t.timestamps
    end
  end
end
