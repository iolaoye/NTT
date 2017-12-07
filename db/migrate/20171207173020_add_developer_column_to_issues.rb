class AddDeveloperColumnToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :developer_id, :integer
  end
end
