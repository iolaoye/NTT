require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'facilityAugmented.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

FacilityAugmented.delete_all
csv.each do |row| 
    puts row.to_hash
    FacilityAugmented.create!(
        {:id => row[0],
         :name => row[1],
         :lease_rate => row[2],
         :new_price => row[3],
         :current_price => row[4],
         :life_remaining => row[5],
         :maintenance_coeff => row[6],
         :loan_interest_rate => row[7],
         :interest_rate_equity => row[8],
         :proportion_debt => row[9],
         :year => row[10]
        }, 
        #:without_protection => true
    )
end