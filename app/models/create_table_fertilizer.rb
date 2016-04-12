class CreateTableFertilizer < ActiveRecord::Base
  attr_accessible :code, :lbs, :name, :nh3, :qn, :qp, :spanish_name, :status=boolean, :type, :yn, :yp
end
