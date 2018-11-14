class AddWatershedIdToFemResult < ActiveRecord::Migration
  def change
    add_column :fem_results, :watershed_id, :integer
  end
end
