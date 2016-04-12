# encoding: UTF-8

class Fertilizer < ActiveRecord::Base
  attr_accessible :code, :name, :qn, :qp, :yn, :yp, :nh3, :type1, :lbs, :status, :spanish_name, :status, :fertilizer_type_id
end
