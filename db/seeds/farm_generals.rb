require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'FarmGeneral.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

FarmGeneral.delete_all
csv.each do |row| 
    puts row.to_hash
    FarmGeneral.create!(
        {:name => row[1],
         :values => row[2] 
        }, 
        #:without_protection => true
    )
end