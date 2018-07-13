class AddAveragesTotalToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :second_avg_marweight_1, :integer
    add_column :aplcat_parameters, :second_num_animal_1, :integer
    add_column :aplcat_parameters, :second_avg_marweight_2, :integer
    add_column :aplcat_parameters, :second_num_animal_2, :integer
    add_column :aplcat_parameters, :second_avg_marweight_3, :integer
    add_column :aplcat_parameters, :second_num_animal_3, :integer
    add_column :aplcat_parameters, :second_avg_marweight_4, :integer
    add_column :aplcat_parameters, :second_num_animal_4, :integer
  end
end
