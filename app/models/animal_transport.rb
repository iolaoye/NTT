class AnimalTransport < ActiveRecord::Base
	attr_accessible :freq_trip, :cattle_pro, :purpose, :trans, :categories_trans, :avg_marweight, :num_animal, :categories_slaug, :mortality_rate, :distance, :trailer_id, :truck_id, :fuel_id, :same_vehicle, :loading, :carcass, :boneless_beef
	has_many :categories
end
