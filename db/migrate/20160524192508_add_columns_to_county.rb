class AddColumnsToCounty < ActiveRecord::Migration
  def change
    add_column :counties, :wind_wp1_code, :integer
    add_column :counties, :wind_wp1_name, :string
  end
end
