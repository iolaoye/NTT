class AddColumnToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :last_simulation, :datetime
  end
end
