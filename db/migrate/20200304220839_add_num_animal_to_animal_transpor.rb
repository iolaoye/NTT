class AddNumAnimalToAnimalTranspor < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :num_animal))
    	add_column :animal_transports, :num_animal, :integer
    end
  end
end
