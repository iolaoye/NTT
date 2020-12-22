class RemoveColumnsFromCountyResult < ActiveRecord::Migration[5.2]
  def change
    remove_column :county_results, :bmp_id, :integer
    remove_column :county_results, :crop_ids, :string
  end
end
