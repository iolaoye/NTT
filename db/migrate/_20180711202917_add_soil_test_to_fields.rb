class AddSoilTestToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :soil_test, :integer
  end
end
