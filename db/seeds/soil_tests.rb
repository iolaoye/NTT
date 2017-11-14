SoilTest.delete_all
SoilTest.create!({:id => 1, :name =>"Fe-strip P", :factor1 => 0.10, :factor2 => 1.61}, :without_protection => true)
SoilTest.create!({:id => 2, :name =>"Olsen P", :factor1 => 14.8, :factor2 => 1.54}, :without_protection => true)
SoilTest.create!({:id => 3, :name =>"Bray-1 P", :factor1 => 10.8, :factor2 => 0.99}, :without_protection => true)
