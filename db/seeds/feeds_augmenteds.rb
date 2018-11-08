require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'feedsAugmented.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

FeedsAugmented.delete_all
csv.each do |row| 
    puts row.to_hash
    FeedsAugmented.create!(
        {:id => row[0],
         :name => row[1],
         :selling_price => row[2],
         :purchase_price => row[3],
         :concentrate => row[4],
         :forage => row[5],
         :grain => row[6],
         :hay => row[7],
         :pasture => row[8],
         :silage => row[9],
         :supplement => row[10]
        }, 
        #:without_protection => true
    )
end