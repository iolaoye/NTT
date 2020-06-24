class AddWatershedIdToAnnualResults < ActiveRecord::Migration[5.2]
  def change
    add_column :annual_results, :watershed_id, :integer
  end
end
