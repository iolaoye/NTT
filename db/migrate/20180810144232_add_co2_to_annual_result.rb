class AddCo2ToAnnualResult < ActiveRecord::Migration
  def change
    add_column :annual_results, :co2, :float
  end
end
