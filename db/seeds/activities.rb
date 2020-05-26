#to update only set update_only to true
# To replace all set update only to false
update_only = false

if update_only then
	Activity.create!({:id => 13,:name => "Harvest and End crop season",:code => 45,:abbreviation => "HARVKILL",:spanish_name => "Cosechar y Terminar Crop",:apex_code => 623451,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)	
else
	Activity.delete_all
	Activity.create!({:id => 1,:name => "Planting",:order => 1,:code => 1,:abbreviation => "PLNT",:spanish_name => "Plantar",:apex_code => 136,:amount_label => "Seeding Amount, Cantidad de Semillas",:amount_units => "(seeds/ft)(optional)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 2,:name => "Fertilizer",:order => 2,:code => 2,:abbreviation => "NUTC",:spanish_name => "Fertilizante",:apex_code => 580,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "Depth, Profundidad",:depth_units => "(in)"}, :without_protection => true)
	Activity.create!({:id => 3,:name => "Tillage",:order => 3,:code => 3,:abbreviation => "TILL",:spanish_name => "Arar",:apex_code => 1,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 4,:name => "Harvest Only",:order => 4,:code => 4,:abbreviation => "HARV",:spanish_name => "Cosechar Solamente",:apex_code => 623,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 13,:name => "Harvest and End crop season",:order => 5,:code => 45,:abbreviation => "HARVKILL",:spanish_name => "Cosechar y Terminar Crop",:apex_code => 623451,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 5,:name => "End crop season",:order => 6,:code => 5,:abbreviation => "KILL",:spanish_name => "Terminar Crop",:apex_code => 451,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 6,:name => "Irrigation (Manual)",:order => 7,:code => 6,:abbreviation => "IRRI",:spanish_name => "Irrigacion (Manual)",:apex_code => 500,:amount_label => "Volume, Volumen",:amount_units => "(in)",:depth_label => "Irrigation Efficiency, Eficiencia",:depth_units => "(0 - 100%)"}, :without_protection => true)
	Activity.create!({:id => 7,:name => "Grazing, Continous ",:order => 8,:code => 7,:abbreviation => "GRAZ",:spanish_name => "Pastoreo Continuo",:apex_code => 426,:amount_label => "Total animal units, Total unidades de Animales",:amount_units => "",:depth_label => "Hours in Field, Horas en la parcela",:depth_units => "(0-24)"}, :without_protection => true)
	Activity.create!({:id => 8,:name => "Stop Continous Grazing",:order => 9,:code => 8,:abbreviation => "STOP",:spanish_name => "Terminar Pastoreo Continou",:apex_code => 427,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 9,:name => "Grazing, Rotational ",:order => 10,:code => 9,:abbreviation => "RGRZ",:spanish_name => "Pastoreo Rotacional", :apex_code => "426",:amount_label => "Total animal units, Total unidades de Animales",:amount_units => "",:depth_label => "Hours in Field, Horas en la parcela",:depth_units => "(0-24)"}, :without_protection => true)
	Activity.create!({:id => 10,:name => "Stop Rotational Grazing",:order => 11,:code => 10,:abbreviation => "RSTP",:spanish_name => "Terminar Pastoreo Rotacional", :apex_code => "427",:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 11,:name => "Burn",:order => 12,:code => 11,:abbreviation => "BURN",:spanish_name => "Quema",:apex_code => 397,:amount_label => "Amount, Cantidad",:amount_units => nil,:depth_label => "(lbs/ac)",:depth_units => ""}, :without_protection => true)
	Activity.create!({:id => 12,:name => "Liming",:order => 13,:code => 12,:abbreviation => "LIME",:spanish_name => "Encalado",:apex_code => 734,:amount_label => "Amount, Cantidad",:amount_units => "(lbs/ac)",:depth_label => "",:depth_units => ""}, :without_protection => true)
	#Activity.create!({:id => 14,:name => "Cover Crop",:code => 10,:abbreviation => "CCRP",:spanish_name => "Cultivo de Proteccion",:apex_code => "",:amount_label => "",:amount_units => nil,:depth_label => "",:depth_units => ""}, :without_protection => true)
end