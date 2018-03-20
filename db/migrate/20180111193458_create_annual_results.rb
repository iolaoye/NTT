class CreateAnnualResults < ActiveRecord::Migration
  def change
    create_table :annual_results do |t|
      t.integer :scenario_id
      t.integer :sub1
      t.integer :year
      t.float :flow
      t.float :qdr
      t.float :surface_flow
      t.float :sed
      t.float :ymnu
      t.float :orgp
      t.float :po4
      t.float :orgn
      t.float :no3
      t.float :qdrn
      t.float :qdrp
      t.float :qn
      t.float :dprk
      t.float :irri
      t.float :pcp
      t.float :n2o
      t.float :prkn

      t.timestamps null: false
    end
  end
end
