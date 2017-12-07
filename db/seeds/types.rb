Type.delete_all

Type.create!({:id => 1,:name => "Error"}, :without_protection => true)
Type.create!({:id => 1,:name => "Change"}, :without_protection => true)
Type.create!({:id => 1,:name => "Addition"}, :without_protection => true)
Type.create!({:id => 1,:name => "Enhancement"}, :without_protection => true)
Type.create!({:id => 1,:name => "Bug"}, :without_protection => true)
Type.create!({:id => 1,:name => "Duplicate"}, :without_protection => true)
Type.create!({:id => 1,:name => "Help Wanted"}, :without_protection => true)
Type.create!({:id => 1,:name => "Invalid"}, :without_protection => true)
Type.create!({:id => 1,:name => "Question"}, :without_protection => true)
