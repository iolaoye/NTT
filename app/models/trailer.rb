class Trailer < ActiveRecord::Base
  #associations
     belongs_to :animal_transport
  #scopes
     default_scope {order("description ASC")}
	def fullname
	  "#{code} #{description}"
	end

end
