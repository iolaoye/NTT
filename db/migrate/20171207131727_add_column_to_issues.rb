class AddColumnToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :priority_id, :integer
  end
end
