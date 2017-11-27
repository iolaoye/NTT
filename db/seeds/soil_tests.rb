SoilTest.delete_all
SoilTest.create!({:id => 1, :name =>"None", :factor1 => 0, :factor2 => 1}, :without_protection => true)
SoilTest.create!({:id => 2, :name =>"Fe-strip P", :factor1 => 0.10, :factor2 => 1.61}, :without_protection => true)
SoilTest.create!({:id => 3, :name =>"Olsen P", :factor1 => 14.8, :factor2 => 1.54}, :without_protection => true)
SoilTest.create!({:id => 4, :name =>"Bray-1 P", :factor1 => 10.8, :factor2 => 0.99}, :without_protection => true)
SoilTest.create!({:id => 5, :name =>"Mehlich3 P", :factor1 => 0, :factor2 => 1}, :without_protection => true)
#SoilTest.create!({:id => 6, :name =>"Other", :factor1 => 0, :factor2 => 1}, :without_protection => true)
