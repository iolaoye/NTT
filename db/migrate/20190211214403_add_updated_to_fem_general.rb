class AddUpdatedToFemGeneral < ActiveRecord::Migration
  def change
    add_column :fem_generals, :updated, :boolean
  end
end
