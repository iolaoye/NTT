require 'digest'

class User < ActiveRecord::Base
 #attributes
	attr_accessor :password
    attr_accessible :email, :hashed_password, :password_confirmation, :name, :company, :password, :admin, :reset_token
 #Associations
	has_many :projects
 #validations
	 validates_uniqueness_of :email
	 validates_length_of :email, :within => 5..50
	 validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i
	 validates_confirmation_of :password
	 validates_length_of :password, :within => 4..20
	 validates_presence_of :password, :if => :password_required?
	 validates_presence_of :name, :company
 #before and after functions
	before_save :encrypt_new_password
	before_save :downcase_email
 #functions
   def self.authenticate(email, password)
     user = find_by_email(email)
     return user if user && user.authenticated?(password)
   end
   def authenticated?(password)
     self.hashed_password == encrypt(password)
   end
	 def create_reset_digest
		 self.reset_token = User.new_token
		 update_attribute(:reset_digest, User.digest(reset_token))
		 update_attribute(:reset_sent_at, Time.zone.now)
	 end
	 def send_password_reset_email
		 UserMailer.password_reset(self).deliver
	 end

	 def send_fields_simulated_email(msg)
		 UserMailer.fields_simulated(self, msg).deliver_now
	 end
	 def self.new_token
		 SecureRandom.urlsafe_base64
	 end
	 def self.digest(string)
		 cost = BCrypt::Engine::MIN_COST
		 BCrypt::Password.create(string, cost: cost)
	 end

	 # Returns true if password_reset sent more than 2 hours earlier
	 def password_reset_expired?
		 reset_sent_at < 2.hours.ago
	 end

 #protected functions
   protected
     def encrypt_new_password
       return if password.blank?
       self.hashed_password = encrypt(password)
     end
     def password_required?
       hashed_password.blank? || password.present?
     end
     def encrypt(string)
       Digest::SHA1.hexdigest(string)
     end
		 def downcase_email
			 self.email = email.downcase
		 end
end
