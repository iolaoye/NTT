class CreateFems < ActiveRecord::Migration[5.2]
  def change
    create_table :fems do |t|
      t.has_many :feeds
      t.has_many :structure
      t.has_many :machine
      t.has_many :other

      t.timestamps null: false
    end
  end
end
