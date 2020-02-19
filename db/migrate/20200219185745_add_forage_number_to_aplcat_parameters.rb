class AddForageNumberToAplcatParameters < ActiveRecord::Migration[5.2]
  def change
    add_column :aplcat_parameters, :number_of_forage, :string
  end
end
