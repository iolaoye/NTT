require 'digest'

class User < ActiveRecord::Base
 #attributes
	attr_accessor :password
    attr_accessible :email, :hashed_password, :password_confirmation, :name, :company, :password, :admin
 #Associations
	has_many :projects
end
