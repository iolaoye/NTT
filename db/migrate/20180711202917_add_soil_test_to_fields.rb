class AddSoilTestToFields < ActiveRecord::Migration
  def change
    add_column :fields, :soil_test, :integer
  end
end
