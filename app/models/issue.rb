class Issue < ActiveRecord::Base
  
  attr_accessible :title, :description, :comment_id, :expired_date, :close_date, :status_id, :user_id, :type_id, :created_at, :updated_at

  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_one :status, :dependent => :destroy
  has_one :type, :dependent => :destroy

  validates_presence_of :title, :description, :status_id, :user_id, :type_id
end
