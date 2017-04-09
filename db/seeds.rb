Crop.find(1).delete
Crop.find(2).delete
Crop.find(3).delete
Crop.find(11).delete
Crop.find(12).delete
Crop.find(30).delete
Crop.create!({:id => 1,:number => 1,:dndc => 3,:code => 'SOYB',:name => 'SOYBEANS',:plant_population_mt => 76,:plant_population_ac => 307561,:plant_population_ft => 7.06,:heat_units => 1400,:lu_number => 3,:soil_group_a => 67,:soil_group_b => 78,:soil_group_c => 85,:soil_group_d => 89,:type1 =>'nil',:yield_unit => 'bu',:bushel_weight => 60,:conversion_factor => 36.66663,:dry_matter => 87,:harvest_code => 568,:planting_code => 136,:state_id => '**',:itil => 1,:to1 => 25,:tb => 10,:dd => 0,:dyam => 120,:spanish_name => 'SOYA'}, :without_protection => true)
Crop.create!({:id => 2,:number => 2,:dndc => 1,:code => 'CORN',:name => 'CORN',:plant_population_mt => 10,:plant_population_ac => 40469,:plant_population_ft => 0.93,:heat_units => 1500,:lu_number => 3,:soil_group_a => 67,:soil_group_b => 78,:soil_group_c => 85,:soil_group_d => 89,:type1 =>'nil',:yield_unit => 'bu',:bushel_weight => 56,:conversion_factor => 39.28573,:dry_matter => 85,:harvest_code => 568,:planting_code => 136,:state_id => '**',:itil => 1,:to1 => 25,:tb => 8,:dd => 0,:dyam => 110,:spanish_name => 'MAIZ'}, :without_protection => true)
Crop.create!({:id => 3,:number => 2,:dndc => 1,:code => 'CORN',:name => 'CORN',:plant_population_mt => 10,:plant_population_ac => 40469,:plant_population_ft => 0.93,:heat_units => 1500,:lu_number => 3,:soil_group_a => 67,:soil_group_b => 78,:soil_group_c => 85,:soil_group_d => 89,:type1 =>'nil',:yield_unit => 'bu',:bushel_weight => 56,:conversion_factor => 39.28573,:dry_matter => 85,:harvest_code => 766,:planting_code => 136,:state_id => 'WA',:itil => 1,:to1 => 25,:tb => 8,:dd => 0,:dyam => 110,:spanish_name => 'MAIZ'}, :without_protection => true)
Crop.create!({:id => 11,:number => 10,:dndc => 2,:code => 'WWHT',:name => 'WINTER WHEAT',:plant_population_mt => 211,:plant_population_ac => 853887,:plant_population_ft => 19.6,:heat_units => 1250,:lu_number => 9,:soil_group_a => 63,:soil_group_b => 75,:soil_group_c => 83,:soil_group_d => 87,:type1 =>'nil',:yield_unit => 'bu',:bushel_weight => 60,:conversion_factor => 36.66663,:dry_matter => 88,:harvest_code => 568,:planting_code => 136,:state_id => '**',:itil => 2,:to1 => 15,:tb => 0,:dd => 0,:dyam => 115,:spanish_name => 'TRIGO DE INVIERNO'}, :without_protection => true)
Crop.create!({:id => 12,:number => 11,:dndc => 6,:code => 'SWHT',:name => 'SPRING WHEAT',:plant_population_mt => 211,:plant_population_ac => 853887,:plant_population_ft => 19.6,:heat_units => 1250,:lu_number => 9,:soil_group_a => 63,:soil_group_b => 75,:soil_group_c => 83,:soil_group_d => 87,:type1 =>'nil',:yield_unit => 'bu',:bushel_weight => 60,:conversion_factor => 36.66663,:dry_matter => 88,:harvest_code => 568,:planting_code => 136,:state_id => '**',:itil => 2,:to1 => 20,:tb => 5,:dd => 0,:dyam => 115,:spanish_name => 'TRIGO DE PRIMAVERA'}, :without_protection => true)
Crop.create!({:id => 30,:number => 29,:dndc => 43,:code => 'CSIL',:name => 'CORN SILAGE',:plant_population_mt => 10,:plant_population_ac => 40469,:plant_population_ft => 0.93,:heat_units => 1500,:lu_number => 3,:soil_group_a => 67,:soil_group_b => 78,:soil_group_c => 85,:soil_group_d => 89,:type1 =>'nil',:yield_unit => 't',:bushel_weight => 0,:conversion_factor => 1,:dry_matter => 33,:harvest_code => 310,:planting_code => 136,:state_id => '**',:itil => 1,:to1 => 25,:tb => 8,:dd => 0,:dyam => 90,:spanish_name => 'SILAGE DE MAIZ'}, :without_protection => true)

County.find(2312).delete
County.create!({:id => 2312, :county_name => 'Washington', :state_id => 38, :county_code => '41067', :status => 1, :county_state_code => 'OR067', :wind_wp1_code => 714, :wind_wp1_name => 'ORPORTLA'}, :without_protection => true)

Bmpsublist.find(2).delete
Bmpsublist.find(4).delete
Bmpsublist.find(5).delete
Bmpsublist.find(6).delete
Bmpsublist.find(7).delete
Bmpsublist.find(12).delete
Bmpsublist.find(13).delete
Bmpsublist.create!({:id => 2, :name => "Autofertigation", :spanish_name => "Fertirrigacion Automatica", :bmplist_id => 1, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 4, :name => "Pads and Pipes", :spanish_name => "Almohadillas y Tuberias", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 5, :name => "Pads and Pipes - Two-Stage Ditch System", :spanish_name => "Almohadillas y Tuberias - Sistema de Zanja de Dos Etapas", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 6, :name => "Pads and Pipes - Ditch Enlargement and Reservoir System", :spanish_name => "Almohadillas y Tuberias - Ampliacion de la Zanja y Sistema de Represa", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 7, :name => "Pads and Pipes - Tailwater Irrigation", :spanish_name => "Almohadillas y Tuberias - Irrigacion desde Reserva", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 12, :name => "Riparian Forest Buffer", :spanish_name => "Bosque Ribereno", :bmplist_id => 4, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 13, :name => "Filter Strip/Riparian Forest", :spanish_name => "Zona de Contencion Filtrante/Bosque Ribereno", :bmplist_id => 4, :status => true}, :without_protection => true)
