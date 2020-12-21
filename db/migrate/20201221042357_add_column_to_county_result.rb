class AddColumnToCountyResult < ActiveRecord::Migration[5.2]
  def change
    add_column :county_results, :orgp_ci, :float
  end
end
