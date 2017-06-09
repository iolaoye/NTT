Tillage.create!({:id => 161,:code => 210,:dndc => 0,:name => 'CHPLGT15',:operation => 0,:eqp => 'CHISEL PLOW GT15FT',:status => true,:abbreviation => 'TILL',:spanish_name =>  'ARADOR CINCEL Mayor the 15ft',:activity_id => 3}, :without_protection => true)

County.find(2261).delete
County.create!({:id => 2261, :county_name => 'Payne', :state_id => 37, :county_code => '40119', :status => 1, :county_state_code => 'OK119', :wind_wp1_code => 688, :wind_wp1_name => 'OKPONCAC'}, :without_protection => true)


load("db/seeds/fertilizers.rb")

load("db/seeds/activities.rb")