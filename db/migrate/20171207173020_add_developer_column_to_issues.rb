class AddDeveloperColumnToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :developer_id, :integer
  end
end
