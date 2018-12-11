require 'csv'

csv_text = File.read(Rails.root.join('db', 'seeds', 'FarmGeneral.csv'))
csv  = CSV.parse(csv_text, :headers => true)
puts csv_text

General.delete_all
csv.each do |row| 
    puts row.to_hash
    General.create!(
        {:id => row[0],
         :name => row[1],
         :value => row[2],
         :project_id => @project.id
        }, 
        #:without_protection => true
    )
end