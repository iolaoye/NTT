require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'FarmGeneral.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

FarmGeneral.delete_all
csv.each do |row| 
    puts row.to_hash
    FarmGeneral.create!(
        {:id => row[0],
         :name => row[1].capitalize,
         :unit => row[2],
         :value => row[3],
         :project_id => @project.id
        }, 
        #:without_protection => true
    )
end

# ORIG
# csv.each do |row| 
#     puts row.to_hash
#     FarmGeneral.create!(
#         {:id => row[0],
#          :name => row[1].capitalize,
#          :value => row[2],
#          :project_id => @project.id
#         }, 
#         #:without_protection => true
#     )
# end