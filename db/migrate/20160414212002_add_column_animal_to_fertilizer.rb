class AddColumnAnimalToFertilizer < ActiveRecord::Migration
  def change
    add_column :fertilizers, :animal, :boolean
  end
end
