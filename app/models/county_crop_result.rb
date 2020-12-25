class CountyCropResult < ApplicationRecord
	  attr_accessible :state_id, :county_id, :scenario_id, :name, :yield, :ws, :ns, :ps, :ts, :yield_ci
  #associations
	  belongs_to :scenario
end
