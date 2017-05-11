FertilizerType.delete_all
FertilizerType.create!({:id => 1,:name => "Commercial Fertilizer",:spanish_name => "Fertilizante Comercial"}, :without_protection => true)
FertilizerType.create!({:id => 2,:name => "Manure",:spanish_name => "Escremento"}, :without_protection => true)

