class AddColumnsToCountyResult < ActiveRecord::Migration[5.2]
  def change
    add_column :county_results, :state_id, :integer
    add_column :county_results, :county_id, :integer
    add_column :county_results, :crop_id, :integer
    add_column :county_results, :bmp_id, :integer
    add_column :county_results, :year, :integer
    add_column :county_results, :flow, :float
    add_column :county_results, :qdr, :float
    add_column :county_results, :surface_flow, :float
    add_column :county_results, :sed, :float
    add_column :county_results, :ymnu, :float
    add_column :county_results, :orgp, :float
    add_column :county_results, :po4, :float
    add_column :county_results, :orgn, :float
    add_column :county_results, :no3, :float
    add_column :county_results, :qdrn, :float
    add_column :county_results, :qdrp, :float
    add_column :county_results, :qn, :float
    add_column :county_results, :dprk, :float
    add_column :county_results, :irri, :float
    add_column :county_results, :pcp, :float
    add_column :county_results, :n2o, :float
    add_column :county_results, :prkn, :float
    add_column :county_results, :co2, :float
    add_column :county_results, :biom, :float
  end
end

