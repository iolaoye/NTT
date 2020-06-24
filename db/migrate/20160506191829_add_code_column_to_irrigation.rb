class AddCodeColumnToIrrigation < ActiveRecord::Migration[5.2]
  def change
    add_column :irrigations, :code, :integer
  end
end
