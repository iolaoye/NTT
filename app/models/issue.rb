class Issue < ActiveRecord::Base
  
  attr_accessible :title, :description, :comment_id, :expected_data, :close_date, :status_id, :user_id, :type_id, :created_at, :updated_at, :developer_id

  belongs_to :user
  belongs_to :status
  belongs_to :type
  belongs_to :importance, foreign_key: 'priority_id'
  has_many :comments, :dependent => :destroy

  validates_presence_of :title, :description, :status_id, :user_id, :type_id
end
