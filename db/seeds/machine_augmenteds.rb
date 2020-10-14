require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'machinAugmented.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

Machine.delete_all
csv.each do |row| 
    puts row.to_hash
    Machine.create!(
        {:id => row[0],
         :name => row[1].capitalize,
         :unit => row[2],
         :lease_rate => row[3],
         :new_price => row[4],
         :new_hours => row[5],
         :current_price => row[6],
         :hours_remaining => row[7],
         :width => row[8],
         :speed => row[9],
         :field_efficiency => row[10],
         :horse_power => row[11],
         :rf1 => row[12],
         :rf2 => row[13],
         :ir_loan => row[14],
         :l_loan => row[15],
         :ir_equity => row[16],
         :p_debt => row[17],
         :year => row[18],
         :rv1 => row[19],
         :rv2 => row[20],
         :project_id => @project.id
     }, 
        #:without_protection => true
    )
end

# ORIGIONAL
# csv.each do |row| 
#     puts row.to_hash
#     Machine.create!(
#         {:id => row[0],
#          :name => row[1].capitalize,
#          :lease_rate => row[4],
#          :new_price => row[5],
#          :new_hours => row[6],
#          :current_price => row[7],
#          :hours_remaining => row[8],
#          :width => row[9],
#          :speed => row[10],
#          :field_efficiency => row[11],
#          :horse_power => row[12],
#          :rf1 => row[13],
#          :rf2 => row[14],
#          :ir_loan => row[15],
#          :l_loan => row[16],
#          :ir_equity => row[17],
#          :p_debt => row[18],
#          :year => row[19],
#          :rv1 => row[20],
#          :rv2 => row[21],
#          :project_id => @project.id
#      }, 
#         #:without_protection => true
#     )
# end