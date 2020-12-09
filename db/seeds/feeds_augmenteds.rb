require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'feedsAugmented.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

FemFeed.delete_all
puts "deleted all"
csv.each do |row| 
    #debugger
    puts row.to_hash
    FemFeed.create!(
        {:id => row[0],
         :name => row[1].capitalize,
         :unit => row[2],
         :selling_price => row[3],
         :purchase_price => row[4],
         :concentrate => row[5],
         :forage => row[6],
         :grain => row[7],
         :hay => row[8],
         :pasture => row[9],
         :silage => row[10],
         :supplement => row[11],
         :project_id => @project.id
        }, 
        #:without_protection => true
    )
end


# csv.each do |row| 
#     puts row.to_hash
#     FemFeed.create!(
#         {:id => row[0],
#          :name => row[1].capitalize,
#          :codes => row[2],
#          :selling_price => row[3],
#          :purchase_price => row[4],
#          :concentrate => row[5],
#          :forage => row[6],
#          :grain => row[7],
#          :hay => row[8],
#          :pasture => row[9],
#          :silage => row[10],
#          :supplement => row[11],
#          :project_id => @project.id
#         }, 
#         #:without_protection => true
#     )
# end