Irrigation.delete_all
Irrigation.create!({:id => 1,:name => "Sprinkle",:status => true,:spanish_name => "Rociado",:code => 500}, :without_protection => true)
Irrigation.create!({:id => 2,:name => "Furrow/Flood",:status => true,:spanish_name => "Surco/Inundacion",:code => 502}, :without_protection => true)
Irrigation.create!({:id => 3,:name => "Drip",:status => true,:spanish_name => "Goteo",:code => 530}, :without_protection => true)
Irrigation.create!({:id => 7,:name => "Furrow Diking",:status => true,:spanish_name => "Dique en Surcos",:code => 502}, :without_protection => true)
Irrigation.create!({:id => 8,:name => "Pads and Pipes - Tailwater Irrigation",:status => true,:spanish_name => "Almuadiallas y Tubos - Irrigacion de Descargue",:code => 502}, :without_protection => true)

