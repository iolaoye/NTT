class AddOrderToActivities < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:activities, :order))
    	add_column :activities, :order, :integer
    end
  end
end
