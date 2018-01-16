class AddWatershedIdToAnnualResults < ActiveRecord::Migration
  def change
    add_column :annual_results, :watershed_id, :integer
  end
end
