class RenameFertilizerColumnTypeToType1 < ActiveRecord::Migration
  def change
	rename_column :fertilizers, :type, :type1
  end
end
