Description.delete_all
Description.create!({:id => 10,:detail => false,:description => "Total Area",:spanish_description => "Area Total",:unit => "ac",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 20,:detail => false,:description => "Total N",:spanish_description => "Total N",:unit => "lbs/ac",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 21,:detail => true,:description => "Org N",:spanish_description => "Org N",:unit => "lbs/ac",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 22,:detail => true,:description => "Runoff N",:spanish_description => "N en Flujo",:unit => "lbs/ac",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 23,:detail => true,:description => "Subsurface N",:spanish_description => "N en Subsuelo",:unit => "lbs/ac",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 24,:detail => true,:description => "Tile Drain N",:spanish_description => "N en Sistema de Drenaje",:unit => "lbs/ac",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 30,:detail => false,:description => "Total P",:spanish_description => "Total P",:unit => "lbs/ac",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 31,:detail => true,:description => "Org P",:spanish_description => "Org P",:unit => "lbs/ac",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 32,:detail => true,:description => "PO4_P",:spanish_description => "PO4_P",:unit => "lbs/ac",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 33,:detail => true,:description => "Tile Drain P",:spanish_description => "P en Sistema de Drenaje",:unit => "lbs/ac",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 40,:detail => false,:description => "Total Flow",:spanish_description => "Flujo Total",:unit => "in",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 41,:detail => true,:description => "Surface Flow",:spanish_description => "Flujo en la Superficie",:unit => "in",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 42,:detail => true,:description => "Subsurface Flow",:spanish_description => "Flujo en Subsuelo",:unit => "in",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 43,:detail => true,:description => "Tile Drain Flow",:spanish_description => "Flujo en Sistema de Drenaje",:unit => "in",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 50,:detail => false,:description => "Total Other Water",:spanish_description => "Flujo Total",:unit => "in",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 51,:detail => true,:description => "Irrigation",:spanish_description => "Irrigación",:unit => "in",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 52,:detail => true,:description => "Deep Percolation",:spanish_description => "Filtración Profunda",:unit => "in",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 60,:detail => false,:description => "Total Sediment",:spanish_description => "Total Sedimento",:unit => "t/ac",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 61,:detail => true,:description => "Sediment",:spanish_description => "Sedimento",:unit => "t/ac",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 62,:detail => true,:description => "Manure Erosion",:spanish_description => "Sedimento por Estíercol",:unit => "t/ac",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 70,:detail => false,:description => "Total Crop Yield",:spanish_description => "Cosecha Producida",:unit => "",:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 71,:detail => true,:description => "Crop 1",:spanish_description => "Crop 1",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 72,:detail => true,:description => "Crop 2",:spanish_description => "Crop 2",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 73,:detail => true,:description => "Crop 3",:spanish_description => "Crop 3",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 74,:detail => true,:description => "Crop 4",:spanish_description => "Crop 4",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 75,:detail => true,:description => "Crop 5",:spanish_description => "Crop 5",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 100,:detail => false,:description => "Precipitation",:spanish_description => "Precipitación",:unit => "in",:position => nil,:period => 1}, :without_protection => true)
Description.create!({:id => 201,:detail => true,:description => "Water Stress 1",:spanish_description => "Water Stress 1",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 202,:detail => true,:description => "Water Stress 2",:spanish_description => "Water Stress 2",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 203,:detail => true,:description => "Water Stress 3",:spanish_description => "Water Stress 3",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 204,:detail => true,:description => "Water Stress 4",:spanish_description => "Water Stress 4",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 205,:detail => true,:description => "Water Stress 5",:spanish_description => "Water Stress 5",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 211,:detail => true,:description => "N Stress 1",:spanish_description => "N Stress 1",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 212,:detail => true,:description => "N Stress 2",:spanish_description => "N Stress 2",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 213,:detail => true,:description => "N Stress 3",:spanish_description => "N Stress 3",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 214,:detail => true,:description => "N Stress 4",:spanish_description => "N Stress 4",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 215,:detail => true,:description => "N Stress 5",:spanish_description => "N Stress 5",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 221,:detail => true,:description => "Temperature Stress 1",:spanish_description => "Temperature Stress 1",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 222,:detail => true,:description => "Temperature Stress 2",:spanish_description => "Temperature Stress 2",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 223,:detail => true,:description => "Temperature Stress 3",:spanish_description => "Temperature Stress 3",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 224,:detail => true,:description => "Temperature Stress 4",:spanish_description => "Temperature Stress 4",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 225,:detail => true,:description => "Temperature Stress 5",:spanish_description => "Temperature Stress 5",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 231,:detail => true,:description => "P Stress 1",:spanish_description => "P Stress 1",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 232,:detail => true,:description => "P Stress 2",:spanish_description => "P Stress 2",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 233,:detail => true,:description => "P Stress 3",:spanish_description => "P Stress 3",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 234,:detail => true,:description => "P Stress 4",:spanish_description => "P Stress 4",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
Description.create!({:id => 235,:detail => true,:description => "P Stress 5",:spanish_description => "P Stress 5",:unit => nil,:position => nil,:period => 2}, :without_protection => true)
