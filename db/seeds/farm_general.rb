require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'farmGeneral.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

FarmGeneral.delete_all
csv.each do || 
    puts row.to_hash
    Bmplist.create!(
        {:id => 1,
         :name => "Autoirrigation and Autofertigation",
         :status => nil,
         :spanish_name => "Autoirrigation and Autofertigacion"
        }, 
        :without_protection => true
    )
end