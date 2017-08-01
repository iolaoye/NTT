Drainage.delete_all
Drainage.create!({:drainage_id => 1, :name => 'Well Drained', :wtmx => 0, :wtmn => 0, :wtbl => 0, :zqt => 0, :ztk => 0}, :without_protection => true)
Drainage.create!({:drainage_id => 2, :name => 'Poorly Drained', :wtmx => 5, :wtmn => 1, :wtbl => 2, :zqt => 2, :ztk => 1}, :without_protection => true)
Drainage.create!({:drainage_id => 3, :name => ' Somewhat Poorly Drained', :wtmx => 6, :wtmn => 1, :wtbl => 2, :zqt => 2, :ztk => 1}, :without_protection => true)