class AddWatershedIdToFemResult < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_results, :watershed_id, :integer
  end
end
