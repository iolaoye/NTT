class AddUpdatedToFields < ActiveRecord::Migration
  def change
    add_column :fields, :updated, :boolean
  end
end