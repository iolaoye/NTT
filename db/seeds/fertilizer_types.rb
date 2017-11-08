FertilizerType.delete_all
FertilizerType.create!({:id => 1,:name => "Commercial Fertilizer",:spanish_name => "Fertilizante Comercial"}, :without_protection => true)
FertilizerType.create!({:id => 2,:name => "Solid Manure",:spanish_name => "Escrementoe Sólido"}, :without_protection => true)
FertilizerType.create!({:id => 3,:name => "Liquid Manure",:spanish_name => "Escremento Líquido"}, :without_protection => true)

