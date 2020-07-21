class AddColumnToBmplists < ActiveRecord::Migration[5.2]
  def change
    add_column :bmplists, :status, :boolean
  end
end
