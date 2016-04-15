# encoding: UTF-8

class Fertilizer < ActiveRecord::Base
  attr_accessible :code, :name, :qn, :qp, :yn, :yp, :nh3, :dry_matter, :status, :spanish_name, :status, :fertilizer_type_id, :convertion_unit, :animal

   #Associations
	belongs_to :fertilizer_type
end
