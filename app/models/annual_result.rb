class AnnualResult < ActiveRecord::Base
	  belongs_to :scenario
	  belongs_to :watershed
end
