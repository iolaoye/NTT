#Crop.find(3).delete

Bmpsublist.delete_all
Bmpsublist.create!({:id => 1, :name => "Autoirrigation/Autofertigation", :spanish_name => "Irrigacion/Fertirrigacion Automatica", :bmplist_id => 1, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 2, :name => "Autofertigation", :spanish_name => "Fertirrigacion Automatica", :bmplist_id => 1, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 3, :name => "Tile Drain", :spanish_name => "Sistema de Drenaje", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 4, :name => "Pads and Pipes", :spanish_name => "Almohadillas y Tuberias", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 5, :name => "Pads and Pipes - Two-Stage Ditch System", :spanish_name => "Almohadillas y Tuberias - Sistema de Zanja de Dos Etapas", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 6, :name => "Pads and Pipes - Ditch Enlargement and Reservoir System", :spanish_name => "Almohadillas y Tuberias - Ampliacion de la Zanja y Sistema de Represa", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 7, :name => "Pads and Pipes - Tailwater Irrigation", :spanish_name => "Almohadillas y Tuberias - Irrigacion desde Reserva", :bmplist_id => 2, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 8, :name => "Wetlands", :spanish_name => "Humedales", :bmplist_id => 3, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 9, :name => "Ponds", :spanish_name => "Lagunas", :bmplist_id => 3, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 10, :name => "Stream Fencing (Livestock Access Control)", :spanish_name => "Cercado del rio (Control de Acceso del Ganado)", :bmplist_id => 4, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 11, :name => "Streambank Stabilization", :spanish_name => "Estabilizacion de la Orilla del rio", :bmplist_id => 4, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 12, :name => "Riparian Forest Buffer", :spanish_name => "Bosque Ribereno", :bmplist_id => 4, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 13, :name => "Filter Strip/Riparian Forest", :spanish_name => "Zona de Contencion Filtrante/Bosque Ribereno", :bmplist_id => 4, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 14, :name => "Grass Waterway", :spanish_name => "Canal de Agua ", :bmplist_id => 4, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 15, :name => "Contour Buffer", :spanish_name => "Buffer de Contorno", :bmplist_id => 5, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 16, :name => "Land Leveling", :spanish_name => "Nivelacion de la Tierra", :bmplist_id => 6, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 17, :name => "Terrace System", :spanish_name => "Sistema de Terraza", :bmplist_id => 6, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 18, :name => "Manure Control", :spanish_name => "Control de Estiercol", :bmplist_id => 6, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 19, :name => "Monthly Temperature and Precipitation Changes", :spanish_name => "Cambios de Temperatura y Precipitacion", :bmplist_id => 7, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 20, :name => "Asphalt or Concrete", :spanish_name => "Asfalto o Concreto", :bmplist_id => 8, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 21, :name => "Grass Cover", :spanish_name => "Cubierta de Pasto", :bmplist_id => 8, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 22, :name => "Slope Adjustment", :spanish_name => "Ajuste de la inclinacion", :bmplist_id => 8, :status => true}, :without_protection => true)
Bmpsublist.create!({:id => 23, :name => "Shading", :spanish_name => "Sombra", :bmplist_id => 8, :status => true}, :without_protection => true)

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
