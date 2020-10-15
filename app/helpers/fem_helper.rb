module FemHelper
    #Load fem feeds if project is new
    def load_feeds
      require 'csv'

      csv_text = File.read(Rails.root.join('db', 'seeds', 'feedsAugmented.csv'))
      csv  = CSV.parse(csv_text, :headers => true)
      puts csv_text

      #FemFeed.delete_all
      csv.each do |row| 
          puts row.to_hash
          FemFeed.create!(
              {
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
               :project_id => @project.id,
               :codes => row[2]
              }, 
              #:without_protection => true
          )
      end  
    end
    #Load fem facilities if project is new
    def load_facilities
      require 'csv'

      csv_text = File.read(Rails.root.join('db', 'seeds', 'facilityAugmented.csv'))
      csv  = CSV.parse(csv_text, :headers => true)
      puts csv_text

      #FemFacility.delete_all
      csv.each do |row| 
          puts row.to_hash
          FemFacility.create!(
              {
               :name => row[1].capitalize,
               :unit => row[2],
               :lease_rate => row[3],
               :new_price => row[4],
               :new_life => row[5],
               :current_price => row[6],
               :life_remaining => row[7],
               :maintenance_coeff => row[8],
               :loan_interest_rate => row[9],
               :length_loan => row[10],
               :interest_rate_equity => row[11],
               :proportion_debt => row[12],
               :year => row[13],
               :project_id => @project.id,
               #:codes => row[2],
               #:ownership => row[3]
          }, 
              #:without_protection => true
          )
      end
    end

    #Load fem generals if project is new
    def load_generals
	    require 'csv'

	    csv_text = File.read(Rails.root.join('db', 'seeds', 'FarmGeneral.csv'))
	    csv  = CSV.parse(csv_text, :headers => true)
	    puts csv_text

	    #FemGeneral.delete_all
	    csv.each do |row| 
	        puts row.to_hash
	        FemGeneral.create!(
	            {
	             :name => row[1].capitalize,
               :unit => row[2],
	             :value => row[3],
	             :project_id => @project.id,	             
	            }, 
	            #:without_protection => true
	        )
	    end
	 end

	#Load fem generals if project is new
    def load_machines
      require 'csv'

      csv_text = File.read(Rails.root.join('db', 'seeds', 'machinAugmented.csv'))
      csv  = CSV.parse(csv_text, :headers => true)
      puts csv_text

      #Machine.delete_all
      csv.each do |row| 
          puts row.to_hash
          FemMachine.create!(
              {
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
               :project_id => @project.id,
               #:codes => row[2],
               #:ownership => row[3]
           }, 
              #:without_protection => true
          )
      end
    end
end
