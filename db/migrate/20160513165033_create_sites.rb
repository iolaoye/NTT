class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.float :ylat
      t.float :xlog
      t.float :elev
      t.float :apm
      t.float :co2x
      t.float :cqnx
      t.float :rfnx
      t.float :upr
      t.float :unr
      t.float :fir0
	  t.integer :field_id

      t.timestamps
    end
  end
end
