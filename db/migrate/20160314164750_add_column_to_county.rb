class AddColumnToCounty < ActiveRecord::Migration[5.2]
  def change
    add_column :counties, :county_state_code, :string
  end
end
