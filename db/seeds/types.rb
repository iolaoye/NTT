Type.delete_all

Type.create!({:id => 1,:name => "Error"}, :without_protection => true)
Type.create!({:id => 2,:name => "Change"}, :without_protection => true)
Type.create!({:id => 3,:name => "Addition"}, :without_protection => true)
Type.create!({:id => 4,:name => "Enhancement"}, :without_protection => true)
Type.create!({:id => 5,:name => "Bug"}, :without_protection => true)
Type.create!({:id => 6,:name => "Duplicate"}, :without_protection => true)
Type.create!({:id => 7,:name => "Help Wanted"}, :without_protection => true)
Type.create!({:id => 8,:name => "Invalid"}, :without_protection => true)
Type.create!({:id => 9,:name => "Question"}, :without_protection => true)
