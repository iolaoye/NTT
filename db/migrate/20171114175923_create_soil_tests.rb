class CreateSoilTests < ActiveRecord::Migration[5.2]
  def change
  	if !ActiveRecord::Base.connection.data_source_exists? "soil_tests"
	    create_table :soil_tests do |t|
	      t.string :name
	      t.float :factor1
	      t.float :factor2

	      t.timestamps null: false
	    end
	end
  end
end
