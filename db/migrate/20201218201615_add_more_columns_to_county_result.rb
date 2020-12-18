class AddMoreColumnsToCountyResult < ActiveRecord::Migration[5.2]
  def change
    add_column :county_results, :scenario_id, :integer
    add_column :county_results, :orgn_ci, :float
    add_column :county_results, :qn_ci, :float
    add_column :county_results, :no3_ci, :float
    add_column :county_results, :qdrn_ci, :float
    add_column :county_results, :po4_ci, :float
    add_column :county_results, :qdrp_ci, :float
    add_column :county_results, :surface_flow_ci, :float
    add_column :county_results, :flow_ci, :float
    add_column :county_results, :qdr_ci, :float
    add_column :county_results, :irri_ci, :float
    add_column :county_results, :dprk_ci, :float
    add_column :county_results, :sed_ci, :float
    add_column :county_results, :ymnu_ci, :float
    add_column :county_results, :co2_ci, :float
    add_column :county_results, :n2o_ci, :float
  end
end
