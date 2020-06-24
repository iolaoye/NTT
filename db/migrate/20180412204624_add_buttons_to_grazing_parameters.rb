class AddButtonsToGrazingParameters < ActiveRecord::Migration[5.2]
  def change
    add_column :grazing_parameters, :for_button, :integer
    add_column :grazing_parameters, :supplement_button, :integer
  end
end
