class CreateAnimalTransport < ActiveRecord::Migration[5.2]
  def change
    create_table :animal_transports do |t|
      t.integer :trip_number
    end
  end
end
