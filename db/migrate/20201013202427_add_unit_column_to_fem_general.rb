class AddUnitColumnToFemGeneral < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_generals, :unit, :string
  end
end
