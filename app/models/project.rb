class Project < ActiveRecord::Base
  attr_accessible :description, :name, :user_id
  #Associatons
    belongs_to :user
	has_one :location, :dependent => :destroy
	has_many :apex_controls, :dependent => :destroy
	has_many :apex_parameters, :dependent => :destroy
	has_many :fields, :through => :location
	has_many :fen_facilities, :dependent => :destroy
	has_many :fem_feeds, :dependent => :destroy
	has_many :fem_generals, :dependent => :destroy
	has_many :fem_machines, :dependent => :destroy
  #validations
	 validates_uniqueness_of :name, :scope => :user_id
	 validates_presence_of :name
end
