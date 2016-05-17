class Scenario < ActiveRecord::Base
  attr_accessible :name, :field_id
  #associations
  has_many :operations, :dependent => :destroy
  has_many :bmps, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_many :subareas
  belongs_to :field
end
