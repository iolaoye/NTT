Priority.delete_all

Priority.create!({:id => 1,:name => "High"}, :without_protection => true)
Priority.create!({:id => 1,:name => "Middle"}, :without_protection => true)
Priority.create!({:id => 1,:name => "Low"}, :without_protection => true)
