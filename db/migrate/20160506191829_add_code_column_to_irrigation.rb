class AddCodeColumnToIrrigation < ActiveRecord::Migration
  def change
    add_column :irrigations, :code, :integer
  end
end
