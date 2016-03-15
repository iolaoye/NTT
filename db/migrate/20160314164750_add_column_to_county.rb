class AddColumnToCounty < ActiveRecord::Migration
  def change
    add_column :counties, :county_state_code, :string
  end
end
