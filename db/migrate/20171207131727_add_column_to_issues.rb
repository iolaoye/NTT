class AddColumnToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :priority_id, :integer
  end
end
