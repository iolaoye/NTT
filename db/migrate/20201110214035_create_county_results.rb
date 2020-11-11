class CreateCountyResults < ActiveRecord::Migration[5.2]
  def change
    create_table :county_results do |t|

      t.timestamps
    end
  end
end
