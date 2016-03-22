class Fertilizer < ActiveRecord::Base
  attr_accessible :abbreviation, :activity_id, :code, :dndc, :name, :operation, :spinsh_name, :status
end
