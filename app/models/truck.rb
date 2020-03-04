class Truck < ActiveRecord::Base
  #associations
     belongs_to :animal_transport
  #scopes
     default_scope {order("description ASC")}

end
