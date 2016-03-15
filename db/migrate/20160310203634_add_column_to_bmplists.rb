class AddColumnToBmplists < ActiveRecord::Migration
  def change
    add_column :bmplists, :status, :boolean
  end
end
