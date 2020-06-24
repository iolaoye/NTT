class AddUpdatedToFemGeneral < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_generals, :updated, :boolean
  end
end
