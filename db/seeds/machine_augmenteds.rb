require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'machinAugmented.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

MachineAugmented.delete_all
csv.each do |row| 
    puts row.to_hash
    MachineAugmented.create!(
        {:id => row[0],
         :name => row[1],
         :lease_rate => row[2],
         :new_price => row[3],
         :new_hours => row[4],
         :current_price => row[5],
         :hours_remaining => row[6],
         :width => row[7],
         :speed => row[8],
         :field_efficiency => row[9],
         :horse_power => row[10],
         :rf1 => row[11],
         :rf2 => row[12],
         :ir_loan => row[13],
         :ir_equity => row[14],
         :p_debt => row[15],
         :year => row[16],
         :rv1 => row[17],
         :rv2 => row[18]
        }, 
        #:without_protection => true
    )
end