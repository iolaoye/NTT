class AddOrgCandNh4NToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :org_c, :float
    add_column :operations, :nh4_n, :float
  end
end
