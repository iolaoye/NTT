Status.delete_all

Status.create!({:id => 1,:name => "Opened"}, :without_protection => true)
Status.create!({:id => 1,:name => "Closed"}, :without_protection => true)
Status.create!({:id => 1,:name => "Suspended"}, :without_protection => true)
Status.create!({:id => 1,:name => "Removed"}, :without_protection => true)
