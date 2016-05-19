class AddColumnCiValueToResult < ActiveRecord::Migration
  def change
    add_column :results, :ci_value, :float
  end
end
