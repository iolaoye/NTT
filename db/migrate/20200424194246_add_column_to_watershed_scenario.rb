class AddColumnToWatershedScenario < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:watershed_scenarios, :field_id_to))
    	add_column :watershed_scenarios, :field_id_to, :string
    end
  end
end
