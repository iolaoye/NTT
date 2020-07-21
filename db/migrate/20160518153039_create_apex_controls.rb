class CreateApexControls < ActiveRecord::Migration[5.2]
  def change
    create_table :apex_controls do |t|
      t.integer :control_id
      t.float :value
	  t.integer :project_id

      t.timestamps
    end
  end
end
