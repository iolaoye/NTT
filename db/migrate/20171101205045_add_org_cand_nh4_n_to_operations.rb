class AddOrgCandNh4NToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :org_c, :float
    add_column :operations, :nh4_n, :float
  end
end
