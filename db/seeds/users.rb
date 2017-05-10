User.delete_all
User.create!({:id => 1,:email => "oscargallegom@hotmail.com",:hashed_password => "7110eda4d09e062aa5e4a390b0a572ac0d2c0220",:name => "osar",:company => "oscar",:admin => true,:password => '1234'}, :without_protection => true)

