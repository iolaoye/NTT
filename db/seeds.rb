
County.find(2261).delete
County.create!({:id => 2261, :county_name => 'Payne', :state_id => 37, :county_code => '40119', :status => 1, :county_state_code => 'OK119', :wind_wp1_code => 688, :wind_wp1_name => 'OKPONCAC'}, :without_protection => true)


load("db/seeds/fertilizers.rb")

load("db/seeds/activities.rb")