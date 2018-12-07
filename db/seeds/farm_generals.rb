require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'FarmGeneral.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

FemGeneral.delete_all
csv.each do |row| 
    puts row.to_hash
    FemGeneral.create!(
        {:id => row[0],
         :name => row[1],
         :value => row[2] 
        }, 
        #:without_protection => true
    )
end