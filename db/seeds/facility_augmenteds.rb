require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'facilityAugmented.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

Facility.delete_all
csv.each do |row| 
    puts row.to_hash
    Facility.create!(
        {:id => row[0],
         :name => row[1].capitalize,
         :lease_rate => row[4],
         :new_price => row[5],
         :new_life => row[6],
         :current_price => row[7],
         :life_remaining => row[8],
         :maintenance_coeff => row[9],
         :loan_interest_rate => row[10],
         :length_loan => row[11],
         :interest_rate_equity => row[12],
         :proportion_debt => row[13],
         :year => row[14],
         :project_id => @project.id
        }, 
        #:without_protection => true
    )
end