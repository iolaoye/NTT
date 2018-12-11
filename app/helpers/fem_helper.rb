module FemHelper
    #Load fem feeds if project is new
    def load_feeds
    	debugger
      require 'csv'

      csv_text = File.read(Rails.root.join('db', 'seeds', 'feedsAugmented.csv'))
      csv  = CSV.parse(csv_text, :headers => true)
      puts csv_text

      #FemFeed.delete_all
      csv.each do |row| 
          puts row.to_hash
          FemFeed.create!(
              {
               :name => row[1],
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
               :name => row[1],
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
               :project_id => @project.id,
               :codes => row[2],
               :ownership => row[3]
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
	             :name => row[1],
	             :value => row[2],
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
               :name => row[1],
               :lease_rate => row[4],
               :new_price => row[5],
               :new_hours => row[6],
               :current_price => row[7],
               :hours_remaining => row[8],
               :width => row[9],
               :speed => row[10],
               :field_efficiency => row[11],
               :horse_power => row[12],
               :rf1 => row[13],
               :rf2 => row[14],
               :ir_loan => row[15],
               :l_loan => row[16],
               :ir_equity => row[17],
               :p_debt => row[18],
               :year => row[19],
               :rv1 => row[20],
               :rv2 => row[21],
               :project_id => @project.id,
               :codes => row[2],
               :ownership => row[3]
           }, 
              #:without_protection => true
          )
      end
    end
end
