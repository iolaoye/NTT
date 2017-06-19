class AddOrderIdToDescriptions < ActiveRecord::Migration
  def change
    add_column :descriptions, :order_id, :integer
    Description.all.each_with_index do |description, index|
      a = Description.where(id: 80).first
      b = Description.where(id: 81).first
      c = Description.where(id: 82).first
      if (description.id >= 30 && description.id <= 32)
      	case (description.id)
      		when 30
      		a.update_attributes!(:order_id => index)
      		when 31
      		b.update_attributes!(:order_id => index)
      		when 32
      		c.update_attributes!(:order_id => index)
      	end
      	index += 3
      	description.update_attributes!(:order_id => index)
      end
      if (description.id >= 80 && description.id <= 82)
      	next
      else
      	description.update_attributes!(:order_id => index)
      end 
    end
  end
end
