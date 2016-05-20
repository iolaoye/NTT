class CreateApexParameters < ActiveRecord::Migration
  def change
    create_table :apex_parameters do |t|
      t.integer :parameter_id
      t.float :value
      t.integer :project_id

      t.timestamps
    end
  end
end
