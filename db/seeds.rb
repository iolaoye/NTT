#Crop.find(3).delete

Bmpsublist.find(14).delete
Bmpsublist.create!({:id => 14, :name => "Grass Waterway", :spanish_name => "Canal de Agua ", :bmplist_id => 4, :status => true}, :without_protection => true)

Activity.delete_all
Activity.create!({:id => 1,:name => "Planting",:code => 1,:abbreviation => "PLNT",:spanish_name => "Plantar",:apex_code => 136,:amount_label => "Seeding Amount, Cantidad de Semillas",:amount_units => "(seeds/ft)",:depth_label => "",:depth_units => ""}, :without_protection => true)
Activity.create!({:id => 2,:name => "Fertilizer",:code => 2,:abbreviation => "NUTC",:spanish_name => "Fertilizante",:apex_code => 580,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "Depth, Profundidad",:depth_units => "(in)"}, :without_protection => true)
Activity.create!({:id => 3,:name => "Tillage",:code => 3,:abbreviation => "TILL",:spanish_name => "Arar",:apex_code => 1,:amount_label => nil,:amount_units => nil,:depth_label => nil,:depth_units => nil}, :without_protection => true)
Activity.create!({:id => 4,:name => "Harvest",:code => 4,:abbreviation => "HARV",:spanish_name => "Cosechar",:apex_code => 623,:amount_label => nil,:amount_units => nil,:depth_label => nil,:depth_units => nil}, :without_protection => true)
Activity.create!({:id => 5,:name => "Kill",:code => 5,:abbreviation => "KILL",:spanish_name => "Terminar",:apex_code => 451,:amount_label => nil,:amount_units => nil,:depth_label => nil,:depth_units => nil}, :without_protection => true)
Activity.create!({:id => 6,:name => "Irrigation (Manual)",:code => 6,:abbreviation => "IRRI",:spanish_name => "Irrigacion (Manual)",:apex_code => 500,:amount_label => "Amount, Cantidad",:amount_units => "(vol)",:depth_label => "Efficiency, Eficiencia",:depth_units => "(fraction)"}, :without_protection => true)
Activity.create!({:id => 7,:name => "Start Grazing",:code => 7,:abbreviation => "GRAZ",:spanish_name => "Iniciar Pasteo",:apex_code => 426,:amount_label => "Number of Animals, Cantidad de Animales",:amount_units => "",:depth_label => "Hours in Field, Horas en la parcela",:depth_units => "(0-24)"}, :without_protection => true)
Activity.create!({:id => 8,:name => "Stop Grazing",:code => 8,:abbreviation => "STOP",:spanish_name => "Terminar Pasteo",:apex_code => 427,:amount_label => nil,:amount_units => nil,:depth_label => nil,:depth_units => nil}, :without_protection => true)
Activity.create!({:id => 9,:name => "Burn",:code => 9,:abbreviation => "BURN",:spanish_name => "Quema",:apex_code => 397,:amount_label => nil,:amount_units => nil,:depth_label => nil,:depth_units => nil}, :without_protection => true)
Activity.create!({:id => 10,:name => "Liming",:code => 10,:abbreviation => "LIME",:spanish_name => "Encalado",:apex_code => 734,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)

CropSchedule.delete_all
CropSchedule.create!({:id => 1, :name =>'Corn', :state_id => 0, :class_id => 0, :status => 1}, :without_protection => true)
CropSchedule.create!({:id => 2, :name =>'Soybean', :state_id => 0, :class_id => 0, :status => 1}, :without_protection => true)
CropSchedule.create!({:id => 3, :name =>'Barley Cover Crop', :state_id => 0, :class_id => 2, :status => 1}, :without_protection => true)
CropSchedule.create!({:id => 4, :name =>'Winter Wheat Cover Crop', :state_id => 0, :class_id => 2, :status => 1}, :without_protection => true)
CropSchedule.create!({:id => 5, :name =>'Argentine Canola', :state_id => 0, :class_id => 1, :status => 1}, :without_protection => true)
