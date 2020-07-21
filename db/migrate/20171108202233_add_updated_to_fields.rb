class AddUpdatedToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :updated, :boolean
  end
end