class CreateTableAplcatParameters < ActiveRecord::Migration
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
	  t.integer :mm_type
	  t.float :fmbmm

      t.timestamps
    end
  end
end
