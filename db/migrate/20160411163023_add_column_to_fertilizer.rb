class AddColumnToFertilizer < ActiveRecord::Migration
  def change
    add_column :fertilizers, :fertilizer_type_id, :integer
  end
end
