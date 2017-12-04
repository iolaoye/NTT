Group.delete_all
Group.create!({:id => 1,:group_name => "Precipitation",:spanish_group_name => "Precipitación"}, :without_protection => true)
Group.create!({:id => 2,:group_name => "Flow",:spanish_group_name => "Fluir"}, :without_protection => true)
Group.create!({:id => 3,:group_name => "Nitrogen Losses",:spanish_group_name => "Pérdidas de Nitrógeno"}, :without_protection => true)
Group.create!({:id => 4,:group_name => "Phosphorous Losses",:spanish_group_name => "Pérdidas de Fósforo"}, :without_protection => true)
Group.create!({:id => 5,:group_name => "Erosion Losses",:spanish_group_name => "Pérdidas de Erosión"}, :without_protection => true)
Group.create!({:id => 6,:group_name => "Crop Yield",:spanish_group_name => "Rendimientos de Cultivos"}, :without_protection => true)
