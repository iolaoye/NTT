class RemoveColumnsFromCountyResult < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:county_results, :bmp_id))
    	remove_column :county_results, :bmp_id, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:county_results, :crop_ids))
    	remove_column :county_results, :crop_ids, :string
    end
  end
end
