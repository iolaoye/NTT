class AddColumnToScenarios < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :last_simulation, :datetime
  end
end
