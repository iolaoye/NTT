class AddSecondaryEmissionInputToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :theta, :float
    add_column :aplcat_parameters, :fge, :float
    add_column :aplcat_parameters, :fde, :float
    add_column :aplcat_parameters, :first_area, :integer
    add_column :aplcat_parameters, :first_equip, :integer
    add_column :aplcat_parameters, :first_fuel, :integer
    add_column :aplcat_parameters, :second_area, :integer
    add_column :aplcat_parameters, :second_equip, :integer
    add_column :aplcat_parameters, :second_fuel, :integer
    add_column :aplcat_parameters, :third_area, :integer
    add_column :aplcat_parameters, :third_equip, :integer
    add_column :aplcat_parameters, :third_fuel, :integer
    add_column :aplcat_parameters, :fourth_area, :integer
    add_column :aplcat_parameters, :fourth_equip, :integer
    add_column :aplcat_parameters, :fourth_fuel, :integer
    add_column :aplcat_parameters, :fifth_area, :integer
    add_column :aplcat_parameters, :fifth_equip, :integer
    add_column :aplcat_parameters, :fifth_fuel, :integer
  end
end
