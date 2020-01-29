class Clime < ActiveRecord::Base
	attr_accessible :field_id, :daily_weather
	#associations
    belongs_to :field
end
