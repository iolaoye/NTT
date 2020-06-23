class AddCo2ToAnnualResult < ActiveRecord::Migration[5.2]
  def change
    add_column :annual_results, :co2, :float
  end
end
