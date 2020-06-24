class AddColumnCiValueToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :ci_value, :float
  end
end
