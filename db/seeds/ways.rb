Way.delete_all
Way.create!({:id => 1,:way_name => "Weather Information Using PRISM Data",:spanish_name => "Informacion del clima usando datos de PRISM",:way_value => "Prism"}, :without_protection => true)
Way.create!({:id => 2,:way_name => "Load your Own Weather File",:spanish_name => "Usar su propio archivo del Clima",:way_value => "Own"}, :without_protection => true)
Way.create!({:id => 3,:way_name => "Load Using Specific Coordinates (USA only)",:spanish_name => "Usando el clima de coordenadas especificas (solamente USA)",:way_value => "Coordinates"}, :without_protection => true)

