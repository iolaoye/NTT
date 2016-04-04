# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

State.delete_all
states = [
    {:id => 1, :state_name => 'Alabama', :state_abbreviation => 'AL', :state_code => '01', :status => 0},
    {:id => 2, :state_name => 'Alaska', :state_abbreviation => 'AK', :state_code => '02', :status => 0},
    {:id => 3, :state_name => 'Arizona', :state_abbreviation => 'AZ', :state_code => '04', :status => 0},
    {:id => 4, :state_name => 'Arkansas', :state_abbreviation => 'AR', :state_code => '05', :status => 0},
    {:id => 5, :state_name => 'California', :state_abbreviation => 'CA', :state_code => '06', :status => 1},
    {:id => 6, :state_name => 'Colorado', :state_abbreviation => 'CO', :state_code => '08', :status => 0},
    {:id => 7, :state_name => 'Connecticut', :state_abbreviation => 'CT', :state_code => '09', :status => 0},
    {:id => 8, :state_name => 'District of Columbia', :state_abbreviation => 'DC', :state_code => '11', :status => 0},
    {:id => 9, :state_name => 'Delaware', :state_abbreviation => 'DE', :state_code => '10', :status => 0},
    {:id => 10, :state_name => 'Florida', :state_abbreviation => 'FL', :state_code => '12', :status => 0},
    {:id => 11, :state_name => 'Georgia', :state_abbreviation => 'GA', :state_code => '13', :status => 0},
    {:id => 12, :state_name => 'Hawaii', :state_abbreviation => 'HI', :state_code => '15', :status => 0},
    {:id => 13, :state_name => 'Idaho', :state_abbreviation => 'ID', :state_code => '16', :status => 0},
    {:id => 14, :state_name => 'Illinois', :state_abbreviation => 'IL', :state_code => '17', :status => 0},
    {:id => 15, :state_name => 'Indiana', :state_abbreviation => 'IN', :state_code => '18', :status => 1},
    {:id => 16, :state_name => 'Iowa', :state_abbreviation => 'IA', :state_code => '19', :status => 0},
    {:id => 17, :state_name => 'Kansas', :state_abbreviation => 'KS', :state_code => '20', :status => 1},
    {:id => 18, :state_name => 'Kentucky', :state_abbreviation => 'KY', :state_code => '21', :status => 1},
    {:id => 19, :state_name => 'Louisiana', :state_abbreviation => 'LA', :state_code => '22', :status => 0},
    {:id => 20, :state_name => 'Maine', :state_abbreviation => 'ME', :state_code => '23', :status => 0},
    {:id => 21, :state_name => 'Maryland', :state_abbreviation => 'MD', :state_code => '24', :status => 1},
    {:id => 22, :state_name => 'Massachusetts', :state_abbreviation => 'MA', :state_code => '25', :status => 0},
    {:id => 23, :state_name => 'Michigan', :state_abbreviation => 'MI', :state_code => '26', :status => 1},
    {:id => 24, :state_name => 'Minnesota', :state_abbreviation => 'MN', :state_code => '27', :status => 0},
    {:id => 25, :state_name => 'Mississippi', :state_abbreviation => 'MS', :state_code => '28', :status => 0},
    {:id => 26, :state_name => 'Missouri', :state_abbreviation => 'MO', :state_code => '29', :status => 1},
    {:id => 27, :state_name => 'Montana', :state_abbreviation => 'MT', :state_code => '30', :status => 0},
    {:id => 28, :state_name => 'Nebraska', :state_abbreviation => 'NE', :state_code => '31', :status => 0},
    {:id => 29, :state_name => 'Nevada', :state_abbreviation => 'NV', :state_code => '32', :status => 0},
    {:id => 30, :state_name => 'New Hampshire', :state_abbreviation => 'NH', :state_code => '33', :status => 0},
    {:id => 31, :state_name => 'New Jersey', :state_abbreviation => 'NJ', :state_code => '34', :status => 0},
    {:id => 32, :state_name => 'New Mexico', :state_abbreviation => 'NM', :state_code => '35', :status => 0},
    {:id => 33, :state_name => 'New York', :state_abbreviation => 'NY', :state_code => '36', :status => 0},
    {:id => 34, :state_name => 'North Carolina', :state_abbreviation => 'NC', :state_code => '37', :status => 0},
    {:id => 35, :state_name => 'North Dakota', :state_abbreviation => 'ND', :state_code => '38', :status => 0},
    {:id => 36, :state_name => 'Ohio', :state_abbreviation => 'OH', :state_code => '39', :status => 1},
    {:id => 37, :state_name => 'Oklahoma', :state_abbreviation => 'OK', :state_code => '40', :status => 1},
    {:id => 38, :state_name => 'Oregon', :state_abbreviation => 'OR', :state_code => '41', :status => 1},
    {:id => 39, :state_name => 'Pennsylvania', :state_abbreviation => 'PA', :state_code => '42', :status => 0},
    {:id => 40, :state_name => 'Rhode Island', :state_abbreviation => 'RI', :state_code => '44', :status => 0},
    {:id => 41, :state_name => 'South Carolina', :state_abbreviation => 'SC', :state_code => '45', :status => 0},
    {:id => 42, :state_name => 'South Dakota', :state_abbreviation => 'SD', :state_code => '46', :status => 0},
    {:id => 43, :state_name => 'Tennessee', :state_abbreviation => 'TN', :state_code => '47', :status => 0},
    {:id => 44, :state_name => 'Texas', :state_abbreviation => 'TX', :state_code => '48', :status => 1},
    {:id => 45, :state_name => 'Utah', :state_abbreviation => 'UT', :state_code => '49', :status => 0},
    {:id => 46, :state_name => 'Vermont', :state_abbreviation => 'VT', :state_code => '50', :status => 0},
    {:id => 47, :state_name => 'Virginia', :state_abbreviation => 'VA', :state_code => '51', :status => 0},
    {:id => 48, :state_name => 'Washington', :state_abbreviation => 'WA', :state_code => '53', :status => 1},
    {:id => 49, :state_name => 'West Virginia', :state_abbreviation => 'WV', :state_code => '54', :status => 0},
    {:id => 50, :state_name => 'Wisconsin', :state_abbreviation => 'WI', :state_code => '55', :status => 0},
    {:id => 51, :state_name => 'Wyoming', :state_abbreviation => 'WY', :state_code => '56', :status => 0}
]
states.each { |state| State.create state, :without_protection => true }

County.delete_all
County.create!({:id => 1, :county_name => "Kent", :state_id => 9, :county_code=> "10001", :status => 0, :county_state_code => "DE001"}, :without_protection => true)
County.create!({:id => 2, :county_name => "New Castle", :state_id => 9, :county_code=> "10003", :status => 0, :county_state_code => "DE003"}, :without_protection => true)
County.create!({:id => 3, :county_name => "Sussex", :state_id => 9, :county_code=> "10005", :status => 0, :county_state_code => "DE005"}, :without_protection => true)
County.create!({:id => 4, :county_name => "Washington, DC", :state_id => 8, :county_code=> "11001", :status => 0, :county_state_code => "DC001"}, :without_protection => true)
County.create!({:id => 5, :county_name => "Allegany", :state_id => 21, :county_code=> "24001", :status => 0, :county_state_code => "MD001"}, :without_protection => true)
County.create!({:id => 6, :county_name => "Anne Arundel", :state_id => 21, :county_code=> "24003", :status => 0, :county_state_code => "MD003"}, :without_protection => true)
County.create!({:id => 7, :county_name => "Baltimore City", :state_id => 21, :county_code=> "24510", :status => 0, :county_state_code => "MD005"}, :without_protection => true)
County.create!({:id => 8, :county_name => "Baltimore", :state_id => 21, :county_code=> "24005", :status => 0, :county_state_code => "10001"}, :without_protection => true)
County.create!({:id => 9, :county_name => "Calvert", :state_id => 21, :county_code=> "24009", :status => 0, :county_state_code => "MD009"}, :without_protection => true)
County.create!({:id => 10, :county_name => "Caroline", :state_id => 21, :county_code=> "24011", :status => 0, :county_state_code => "MD011"}, :without_protection => true)
County.create!({:id => 11, :county_name => "Carroll", :state_id => 21, :county_code=> "24013", :status => 0, :county_state_code => "MD013"}, :without_protection => true)
County.create!({:id => 12, :county_name => "Cecil", :state_id => 21, :county_code=> "24015", :status => 0, :county_state_code => "MD015"}, :without_protection => true)
County.create!({:id => 13, :county_name => "Charles", :state_id => 21, :county_code=> "24017", :status => 0, :county_state_code => "MD017"}, :without_protection => true)
County.create!({:id => 14, :county_name => "Dorchester", :state_id => 21, :county_code=> "24019", :status => 0, :county_state_code => "MD019"}, :without_protection => true)
County.create!({:id => 15, :county_name => "Frederick", :state_id => 21, :county_code=> "24021", :status => 0, :county_state_code => "MD021"}, :without_protection => true)
County.create!({:id => 16, :county_name => "Garrett", :state_id => 21, :county_code=> "24023", :status => 0, :county_state_code => "MD023"}, :without_protection => true)
County.create!({:id => 17, :county_name => "Harford", :state_id => 21, :county_code=> "24025", :status => 0, :county_state_code => "MD025"}, :without_protection => true)
County.create!({:id => 18, :county_name => "Howard", :state_id => 21, :county_code=> "24027", :status => 0, :county_state_code => "MD027"}, :without_protection => true)
County.create!({:id => 19, :county_name => "Kent", :state_id => 21, :county_code=> "24029", :status => 0, :county_state_code => "MD029"}, :without_protection => true)
County.create!({:id => 20, :county_name => "Montgomery", :state_id => 21, :county_code=> "24031", :status => 0, :county_state_code => "MD031"}, :without_protection => true)
County.create!({:id => 21, :county_name => "Prince Georges", :state_id => 21, :county_code=> "24033", :status => 0, :county_state_code => "MD033"}, :without_protection => true)
County.create!({:id => 22, :county_name => "Queen Annes", :state_id => 21, :county_code=> "24035", :status => 0, :county_state_code => "MD035"}, :without_protection => true)
County.create!({:id => 23, :county_name => "Somerset", :state_id => 21, :county_code=> "24039", :status => 0, :county_state_code => "MD039"}, :without_protection => true)
County.create!({:id => 24, :county_name => "St. Marys", :state_id => 21, :county_code=> "24037", :status => 0, :county_state_code => "MD037"}, :without_protection => true)
County.create!({:id => 25, :county_name => "Talbot", :state_id => 21, :county_code=> "24041", :status => 0, :county_state_code => "MD041"}, :without_protection => true)
County.create!({:id => 26, :county_name => "Washington", :state_id => 21, :county_code=> "24043", :status => 0, :county_state_code => "MD043"}, :without_protection => true)
County.create!({:id => 27, :county_name => "Wicomico", :state_id => 21, :county_code=> "24045", :status => 0, :county_state_code => "MD045"}, :without_protection => true)
County.create!({:id => 28, :county_name => "Worcester", :state_id => 21, :county_code=> "24047", :status => 0, :county_state_code => "MD047"}, :without_protection => true)
County.create!({:id => 29, :county_name => "Allegany", :state_id => 33, :county_code=> "36003", :status => 0, :county_state_code => "NY003"}, :without_protection => true)
County.create!({:id => 30, :county_name => "Broome", :state_id => 33, :county_code=> "36007", :status => 0, :county_state_code => "NY007"}, :without_protection => true)
County.create!({:id => 31, :county_name => "Chemung", :state_id => 33, :county_code=> "36015", :status => 0, :county_state_code => "NY015"}, :without_protection => true)
County.create!({:id => 32, :county_name => "Chenango", :state_id => 33, :county_code=> "36017", :status => 0, :county_state_code => "NY017"}, :without_protection => true)
County.create!({:id => 33, :county_name => "Cortland", :state_id => 33, :county_code=> "36023", :status => 0, :county_state_code => "NY023"}, :without_protection => true)
County.create!({:id => 34, :county_name => "Delaware", :state_id => 33, :county_code=> "36025", :status => 0, :county_state_code => "NY025"}, :without_protection => true)
County.create!({:id => 35, :county_name => "Herkimer", :state_id => 33, :county_code=> "36043", :status => 0, :county_state_code => "NY043"}, :without_protection => true)
County.create!({:id => 36, :county_name => "Livingston", :state_id => 33, :county_code=> "36051", :status => 0, :county_state_code => "NY051"}, :without_protection => true)
County.create!({:id => 37, :county_name => "Madison", :state_id => 33, :county_code=> "36053", :status => 0, :county_state_code => "NY053"}, :without_protection => true)
County.create!({:id => 38, :county_name => "Oneida", :state_id => 33, :county_code=> "36065", :status => 0, :county_state_code => "NY065"}, :without_protection => true)
County.create!({:id => 39, :county_name => "Onondaga", :state_id => 33, :county_code=> "36067", :status => 0, :county_state_code => "NY067"}, :without_protection => true)
County.create!({:id => 40, :county_name => "Ontario", :state_id => 33, :county_code=> "36069", :status => 0, :county_state_code => "NY069"}, :without_protection => true)
County.create!({:id => 41, :county_name => "Otsego", :state_id => 33, :county_code=> "36077", :status => 0, :county_state_code => "NY077"}, :without_protection => true)
County.create!({:id => 42, :county_name => "Schoharie", :state_id => 33, :county_code=> "36095", :status => 0, :county_state_code => "NY095"}, :without_protection => true)
County.create!({:id => 43, :county_name => "Schuyler", :state_id => 33, :county_code=> "36097", :status => 0, :county_state_code => "NY097"}, :without_protection => true)
County.create!({:id => 44, :county_name => "Steuben", :state_id => 33, :county_code=> "36101", :status => 0, :county_state_code => "NY101"}, :without_protection => true)
County.create!({:id => 45, :county_name => "Tioga", :state_id => 33, :county_code=> "36107", :status => 0, :county_state_code => "NY107"}, :without_protection => true)
County.create!({:id => 46, :county_name => "Tompkins", :state_id => 33, :county_code=> "36109", :status => 0, :county_state_code => "NY109"}, :without_protection => true)
County.create!({:id => 47, :county_name => "Yates", :state_id => 33, :county_code=> "36123", :status => 0, :county_state_code => "NY123"}, :without_protection => true)
County.create!({:id => 48, :county_name => "Adams", :state_id => 39, :county_code=> "42001", :status => 0, :county_state_code => "PA001"}, :without_protection => true)
County.create!({:id => 49, :county_name => "Bedford", :state_id => 39, :county_code=> "42009", :status => 0, :county_state_code => "PA009"}, :without_protection => true)
County.create!({:id => 50, :county_name => "Berks", :state_id => 39, :county_code=> "42011", :status => 0, :county_state_code => "PA011"}, :without_protection => true)
County.create!({:id => 51, :county_name => "Blair", :state_id => 39, :county_code=> "42013", :status => 0, :county_state_code => "PA013"}, :without_protection => true)
County.create!({:id => 52, :county_name => "Bradford", :state_id => 39, :county_code=> "42015", :status => 0, :county_state_code => "PA015"}, :without_protection => true)
County.create!({:id => 53, :county_name => "Cambria", :state_id => 39, :county_code=> "42021", :status => 0, :county_state_code => "PA021"}, :without_protection => true)
County.create!({:id => 54, :county_name => "Cameron", :state_id => 39, :county_code=> "42023", :status => 0, :county_state_code => "PA023"}, :without_protection => true)
County.create!({:id => 55, :county_name => "Carbon", :state_id => 39, :county_code=> "42025", :status => 0, :county_state_code => "PA025"}, :without_protection => true)
County.create!({:id => 56, :county_name => "Centre", :state_id => 39, :county_code=> "42027", :status => 0, :county_state_code => "PA027"}, :without_protection => true)
County.create!({:id => 57, :county_name => "Chester", :state_id => 39, :county_code=> "42029", :status => 0, :county_state_code => "PA029"}, :without_protection => true)
County.create!({:id => 58, :county_name => "Clearfield", :state_id => 39, :county_code=> "42033", :status => 0, :county_state_code => "PA033"}, :without_protection => true)
County.create!({:id => 59, :county_name => "Clinton", :state_id => 39, :county_code=> "42035", :status => 0, :county_state_code => "PA035"}, :without_protection => true)
County.create!({:id => 60, :county_name => "Columbia", :state_id => 39, :county_code=> "42037", :status => 0, :county_state_code => "PA037"}, :without_protection => true)
County.create!({:id => 61, :county_name => "Cumberland", :state_id => 39, :county_code=> "42041", :status => 0, :county_state_code => "PA041"}, :without_protection => true)
County.create!({:id => 62, :county_name => "Dauphin", :state_id => 39, :county_code=> "42043", :status => 0, :county_state_code => "PA043"}, :without_protection => true)
County.create!({:id => 63, :county_name => "Elk", :state_id => 39, :county_code=> "42047", :status => 0, :county_state_code => "PA047"}, :without_protection => true)
County.create!({:id => 64, :county_name => "Franklin City", :state_id => 39, :county_code=> "42055", :status => 0, :county_state_code => "PA055"}, :without_protection => true)
County.create!({:id => 65, :county_name => "Fulton", :state_id => 39, :county_code=> "42057", :status => 0, :county_state_code => "PA057"}, :without_protection => true)
County.create!({:id => 66, :county_name => "Huntingdon", :state_id => 39, :county_code=> "42061", :status => 0, :county_state_code => "PA061"}, :without_protection => true)
County.create!({:id => 67, :county_name => "Indiana", :state_id => 39, :county_code=> "42063", :status => 0, :county_state_code => "PA063"}, :without_protection => true)
County.create!({:id => 68, :county_name => "Jefferson", :state_id => 39, :county_code=> "42065", :status => 0, :county_state_code => "PA065"}, :without_protection => true)
County.create!({:id => 69, :county_name => "Juniata", :state_id => 39, :county_code=> "42067", :status => 0, :county_state_code => "PA067"}, :without_protection => true)
County.create!({:id => 70, :county_name => "Lackawanna", :state_id => 39, :county_code=> "42069", :status => 0, :county_state_code => "PA069"}, :without_protection => true)
County.create!({:id => 71, :county_name => "Lancaster", :state_id => 39, :county_code=> "42071", :status => 0, :county_state_code => "PA071"}, :without_protection => true)
County.create!({:id => 72, :county_name => "Lebanon", :state_id => 39, :county_code=> "42075", :status => 0, :county_state_code => "PA075"}, :without_protection => true)
County.create!({:id => 73, :county_name => "Luzerne", :state_id => 39, :county_code=> "42079", :status => 0, :county_state_code => "PA079"}, :without_protection => true)
County.create!({:id => 74, :county_name => "Lycoming", :state_id => 39, :county_code=> "42081", :status => 0, :county_state_code => "PA081"}, :without_protection => true)
County.create!({:id => 75, :county_name => "Mckean", :state_id => 39, :county_code=> "42083", :status => 0, :county_state_code => "PA083"}, :without_protection => true)
County.create!({:id => 76, :county_name => "Mifflin", :state_id => 39, :county_code=> "42087", :status => 0, :county_state_code => "PA087"}, :without_protection => true)
County.create!({:id => 77, :county_name => "Montour", :state_id => 39, :county_code=> "42093", :status => 0, :county_state_code => "PA093"}, :without_protection => true)
County.create!({:id => 78, :county_name => "Northumberland", :state_id => 39, :county_code=> "42097", :status => 0, :county_state_code => "PA097"}, :without_protection => true)
County.create!({:id => 79, :county_name => "Perry", :state_id => 39, :county_code=> "42099", :status => 0, :county_state_code => "PA099"}, :without_protection => true)
County.create!({:id => 80, :county_name => "Potter", :state_id => 39, :county_code=> "42105", :status => 0, :county_state_code => "PA105"}, :without_protection => true)
County.create!({:id => 81, :county_name => "Schuylkill", :state_id => 39, :county_code=> "42107", :status => 0, :county_state_code => "PA107"}, :without_protection => true)
County.create!({:id => 82, :county_name => "Snyder", :state_id => 39, :county_code=> "42109", :status => 0, :county_state_code => "PA109"}, :without_protection => true)
County.create!({:id => 83, :county_name => "Somerset", :state_id => 39, :county_code=> "42111", :status => 0, :county_state_code => "PA111"}, :without_protection => true)
County.create!({:id => 84, :county_name => "Sullivan", :state_id => 39, :county_code=> "42113", :status => 0, :county_state_code => "PA113"}, :without_protection => true)
County.create!({:id => 85, :county_name => "Susquehanna", :state_id => 39, :county_code=> "42115", :status => 0, :county_state_code => "PA115"}, :without_protection => true)
County.create!({:id => 86, :county_name => "Tioga", :state_id => 39, :county_code=> "42117", :status => 0, :county_state_code => "PA117"}, :without_protection => true)
County.create!({:id => 87, :county_name => "Union", :state_id => 39, :county_code=> "42119", :status => 0, :county_state_code => "PA119"}, :without_protection => true)
County.create!({:id => 88, :county_name => "Wayne", :state_id => 39, :county_code=> "42127", :status => 0, :county_state_code => "PA127"}, :without_protection => true)
County.create!({:id => 89, :county_name => "Wyoming", :state_id => 39, :county_code=> "42131", :status => 0, :county_state_code => "PA131"}, :without_protection => true)
County.create!({:id => 90, :county_name => "York", :state_id => 39, :county_code=> "42133", :status => 0, :county_state_code => "PA133"}, :without_protection => true)
County.create!({:id => 91, :county_name => "Accomack", :state_id => 47, :county_code=> "51001", :status => 0, :county_state_code => "VA001"}, :without_protection => true)
County.create!({:id => 92, :county_name => "Albemarle", :state_id => 47, :county_code=> "51003", :status => 0, :county_state_code => "VA003"}, :without_protection => true)
County.create!({:id => 93, :county_name => "Alleghany", :state_id => 47, :county_code=> "51005", :status => 0, :county_state_code => "VA005"}, :without_protection => true)
County.create!({:id => 94, :county_name => "Amelia", :state_id => 47, :county_code=> "51007", :status => 0, :county_state_code => "VA007"}, :without_protection => true)
County.create!({:id => 95, :county_name => "Amherst", :state_id => 47, :county_code=> "51009", :status => 0, :county_state_code => "VA009"}, :without_protection => true)
County.create!({:id => 96, :county_name => "Appomattox", :state_id => 47, :county_code=> "51011", :status => 0, :county_state_code => "VA011"}, :without_protection => true)
County.create!({:id => 97, :county_name => "Arlington", :state_id => 47, :county_code=> "51013", :status => 0, :county_state_code => "VA013"}, :without_protection => true)
County.create!({:id => 98, :county_name => "Augusta", :state_id => 47, :county_code=> "51015", :status => 0, :county_state_code => "VA015"}, :without_protection => true)
County.create!({:id => 99, :county_name => "Bath", :state_id => 47, :county_code=> "51017", :status => 0, :county_state_code => "VA017"}, :without_protection => true)
County.create!({:id => 100, :county_name => "Bedford", :state_id => 47, :county_code=> "51019", :status => 0, :county_state_code => "VA019"}, :without_protection => true)
County.create!({:id => 101, :county_name => "Botetourt", :state_id => 47, :county_code=> "51023", :status => 0, :county_state_code => "VA023"}, :without_protection => true)
County.create!({:id => 102, :county_name => "Buckingham", :state_id => 47, :county_code=> "51029", :status => 0, :county_state_code => "VA029"}, :without_protection => true)
County.create!({:id => 103, :county_name => "Buena Vista", :state_id => 47, :county_code=> "51530", :status => 0, :county_state_code => "VA530"}, :without_protection => true)
County.create!({:id => 104, :county_name => "Campbell", :state_id => 47, :county_code=> "51031", :status => 0, :county_state_code => "VA031"}, :without_protection => true)
County.create!({:id => 105, :county_name => "Caroline", :state_id => 47, :county_code=> "51033", :status => 0, :county_state_code => "VA033"}, :without_protection => true)
County.create!({:id => 106, :county_name => "Charles City", :state_id => 47, :county_code=> "51036", :status => 0, :county_state_code => "VA036"}, :without_protection => true)
County.create!({:id => 107, :county_name => "Charlottesville City", :state_id => 47, :county_code=> "51540", :status => 0, :county_state_code => "VA540"}, :without_protection => true)
County.create!({:id => 108, :county_name => "Chesapeake City", :state_id => 47, :county_code=> "51550", :status => 0, :county_state_code => "VA550"}, :without_protection => true)
County.create!({:id => 109, :county_name => "Chesterfield", :state_id => 47, :county_code=> "51041", :status => 0, :county_state_code => "VA041"}, :without_protection => true)
County.create!({:id => 110, :county_name => "City Of Alexandria", :state_id => 47, :county_code=> "51510", :status => 0, :county_state_code => "VA510"}, :without_protection => true)
County.create!({:id => 111, :county_name => "Clarke", :state_id => 47, :county_code=> "51043", :status => 0, :county_state_code => "VA043"}, :without_protection => true)
County.create!({:id => 112, :county_name => "Colonial Heights City", :state_id => 47, :county_code=> "51570", :status => 0, :county_state_code => "VA570"}, :without_protection => true)
County.create!({:id => 113, :county_name => "Covington City", :state_id => 47, :county_code=> "51580", :status => 0, :county_state_code => "VA580"}, :without_protection => true)
County.create!({:id => 114, :county_name => "Craig", :state_id => 47, :county_code=> "51045", :status => 0, :county_state_code => "VA045"}, :without_protection => true)
County.create!({:id => 115, :county_name => "Culpeper", :state_id => 47, :county_code=> "51047", :status => 0, :county_state_code => "VA047"}, :without_protection => true)
County.create!({:id => 116, :county_name => "Cumberland", :state_id => 47, :county_code=> "51049", :status => 0, :county_state_code => "VA049"}, :without_protection => true)
County.create!({:id => 117, :county_name => "Dinwiddie", :state_id => 47, :county_code=> "51053", :status => 0, :county_state_code => "VA053"}, :without_protection => true)
County.create!({:id => 118, :county_name => "Essex", :state_id => 47, :county_code=> "51057", :status => 0, :county_state_code => "VA047"}, :without_protection => true)
County.create!({:id => 119, :county_name => "Fairfax City", :state_id => 47, :county_code=> "51600", :status => 0, :county_state_code => "VA600"}, :without_protection => true)
County.create!({:id => 120, :county_name => "Fairfax", :state_id => 47, :county_code=> "51059", :status => 0, :county_state_code => "VA059"}, :without_protection => true)
County.create!({:id => 121, :county_name => "Falls Church City", :state_id => 47, :county_code=> "51610", :status => 0, :county_state_code => "VA610"}, :without_protection => true)
County.create!({:id => 122, :county_name => "Fauquier", :state_id => 47, :county_code=> "51061", :status => 0, :county_state_code => "VA061"}, :without_protection => true)
County.create!({:id => 123, :county_name => "Fluvanna", :state_id => 47, :county_code=> "51065", :status => 0, :county_state_code => "VA065"}, :without_protection => true)
County.create!({:id => 124, :county_name => "Frederick", :state_id => 47, :county_code=> "51069", :status => 0, :county_state_code => "VA069"}, :without_protection => true)
County.create!({:id => 125, :county_name => "Fredericksburg City", :state_id => 47, :county_code=> "51630", :status => 0, :county_state_code => "VA630"}, :without_protection => true)
County.create!({:id => 126, :county_name => "Giles", :state_id => 47, :county_code=> "51071", :status => 0, :county_state_code => "VA071"}, :without_protection => true)
County.create!({:id => 127, :county_name => "Gloucester", :state_id => 47, :county_code=> "51073", :status => 0, :county_state_code => "VA073"}, :without_protection => true)
County.create!({:id => 128, :county_name => "Goochland", :state_id => 47, :county_code=> "51075", :status => 0, :county_state_code => "VA075"}, :without_protection => true)
County.create!({:id => 129, :county_name => "Greene", :state_id => 47, :county_code=> "51079", :status => 0, :county_state_code => "VA079"}, :without_protection => true)
County.create!({:id => 130, :county_name => "Hampton City", :state_id => 47, :county_code=> "51650", :status => 0, :county_state_code => "VA650"}, :without_protection => true)
County.create!({:id => 131, :county_name => "Hanover", :state_id => 47, :county_code=> "51085", :status => 0, :county_state_code => "VA085"}, :without_protection => true)
County.create!({:id => 132, :county_name => "Harrisonburg City", :state_id => 47, :county_code=> "51660", :status => 0, :county_state_code => "VA660"}, :without_protection => true)
County.create!({:id => 133, :county_name => "Henrico", :state_id => 47, :county_code=> "51087", :status => 0, :county_state_code => "VA087"}, :without_protection => true)
County.create!({:id => 134, :county_name => "Highland", :state_id => 47, :county_code=> "51091", :status => 0, :county_state_code => "VA091"}, :without_protection => true)
County.create!({:id => 135, :county_name => "Hopewell City", :state_id => 47, :county_code=> "51670", :status => 0, :county_state_code => "VA670"}, :without_protection => true)
County.create!({:id => 136, :county_name => "Isle Of Wight", :state_id => 47, :county_code=> "51093", :status => 0, :county_state_code => "VA093"}, :without_protection => true)
County.create!({:id => 137, :county_name => "James City", :state_id => 47, :county_code=> "51095", :status => 0, :county_state_code => "VA095"}, :without_protection => true)
County.create!({:id => 138, :county_name => "King And Queen", :state_id => 47, :county_code=> "51097", :status => 0, :county_state_code => "VA097"}, :without_protection => true)
County.create!({:id => 139, :county_name => "King George", :state_id => 47, :county_code=> "51099", :status => 0, :county_state_code => "VA099"}, :without_protection => true)
County.create!({:id => 140, :county_name => "King William", :state_id => 47, :county_code=> "51101", :status => 0, :county_state_code => "VA101"}, :without_protection => true)
County.create!({:id => 141, :county_name => "Lancaster", :state_id => 47, :county_code=> "51103", :status => 0, :county_state_code => "VA103"}, :without_protection => true)
County.create!({:id => 142, :county_name => "Lexington City", :state_id => 47, :county_code=> "51678", :status => 0, :county_state_code => "VA678"}, :without_protection => true)
County.create!({:id => 143, :county_name => "Loudoun", :state_id => 47, :county_code=> "51107", :status => 0, :county_state_code => "VA107"}, :without_protection => true)
County.create!({:id => 144, :county_name => "Louisa", :state_id => 47, :county_code=> "51109", :status => 0, :county_state_code => "VA109"}, :without_protection => true)
County.create!({:id => 145, :county_name => "Lynchburg City", :state_id => 47, :county_code=> "51680", :status => 0, :county_state_code => "VA680"}, :without_protection => true)
County.create!({:id => 146, :county_name => "Madison", :state_id => 47, :county_code=> "51113", :status => 0, :county_state_code => "VA113"}, :without_protection => true)
County.create!({:id => 147, :county_name => "Manassas City", :state_id => 47, :county_code=> "51683", :status => 0, :county_state_code => "VA683"}, :without_protection => true)
County.create!({:id => 148, :county_name => "Manassas Park City", :state_id => 47, :county_code=> "51685", :status => 0, :county_state_code => "VA685"}, :without_protection => true)
County.create!({:id => 149, :county_name => "Mathews", :state_id => 47, :county_code=> "51115", :status => 0, :county_state_code => "VA115"}, :without_protection => true)
County.create!({:id => 150, :county_name => "Middlesex", :state_id => 47, :county_code=> "51119", :status => 0, :county_state_code => "VA119"}, :without_protection => true)
County.create!({:id => 151, :county_name => "Montgomery", :state_id => 47, :county_code=> "51121", :status => 0, :county_state_code => "VA121"}, :without_protection => true)
County.create!({:id => 152, :county_name => "Nelson", :state_id => 47, :county_code=> "51125", :status => 0, :county_state_code => "VA125"}, :without_protection => true)
County.create!({:id => 153, :county_name => "New Kent", :state_id => 47, :county_code=> "51127", :status => 0, :county_state_code => "VA127"}, :without_protection => true)
County.create!({:id => 154, :county_name => "Newport News City", :state_id => 47, :county_code=> "51700", :status => 0, :county_state_code => "VA700"}, :without_protection => true)
County.create!({:id => 155, :county_name => "Norfolk City", :state_id => 47, :county_code=> "51710", :status => 0, :county_state_code => "VA710"}, :without_protection => true)
County.create!({:id => 156, :county_name => "Northampton", :state_id => 47, :county_code=> "51131", :status => 0, :county_state_code => "VA161"}, :without_protection => true)
County.create!({:id => 157, :county_name => "Northumberland", :state_id => 47, :county_code=> "51133", :status => 0, :county_state_code => "VA133"}, :without_protection => true)
County.create!({:id => 158, :county_name => "Nottoway", :state_id => 47, :county_code=> "51135", :status => 0, :county_state_code => "VA135"}, :without_protection => true)
County.create!({:id => 159, :county_name => "Orange", :state_id => 47, :county_code=> "51137", :status => 0, :county_state_code => "VA137"}, :without_protection => true)
County.create!({:id => 160, :county_name => "Page", :state_id => 47, :county_code=> "51139", :status => 0, :county_state_code => "VA139"}, :without_protection => true)
County.create!({:id => 161, :county_name => "Petersburg City", :state_id => 47, :county_code=> "51730", :status => 0, :county_state_code => "VA730"}, :without_protection => true)
County.create!({:id => 162, :county_name => "Poquoson City", :state_id => 47, :county_code=> "51735", :status => 0, :county_state_code => "VA735"}, :without_protection => true)
County.create!({:id => 163, :county_name => "Portsmouth City", :state_id => 47, :county_code=> "51740", :status => 0, :county_state_code => "VA740"}, :without_protection => true)
County.create!({:id => 164, :county_name => "Powhatan", :state_id => 47, :county_code=> "51145", :status => 0, :county_state_code => "VA145"}, :without_protection => true)
County.create!({:id => 165, :county_name => "Prince Edward", :state_id => 47, :county_code=> "51147", :status => 0, :county_state_code => "VA147"}, :without_protection => true)
County.create!({:id => 166, :county_name => "Prince George", :state_id => 47, :county_code=> "51149", :status => 0, :county_state_code => "VA149"}, :without_protection => true)
County.create!({:id => 167, :county_name => "Prince William", :state_id => 47, :county_code=> "51153", :status => 0, :county_state_code => "VA153"}, :without_protection => true)
County.create!({:id => 168, :county_name => "Rappahannock", :state_id => 47, :county_code=> "51157", :status => 0, :county_state_code => "VA157"}, :without_protection => true)
County.create!({:id => 169, :county_name => "Richmond City", :state_id => 47, :county_code=> "51760", :status => 0, :county_state_code => "VA760"}, :without_protection => true)
County.create!({:id => 170, :county_name => "Richmond", :state_id => 47, :county_code=> "51159", :status => 0, :county_state_code => "VA159"}, :without_protection => true)
County.create!({:id => 171, :county_name => "Roanoke", :state_id => 47, :county_code=> "51161", :status => 0, :county_state_code => "VA161"}, :without_protection => true)
County.create!({:id => 172, :county_name => "Rockbridge", :state_id => 47, :county_code=> "51163", :status => 0, :county_state_code => "VA163"}, :without_protection => true)
County.create!({:id => 173, :county_name => "Rockingham", :state_id => 47, :county_code=> "51165", :status => 0, :county_state_code => "VA165"}, :without_protection => true)
County.create!({:id => 174, :county_name => "Shenandoah", :state_id => 47, :county_code=> "51171", :status => 0, :county_state_code => "VA171"}, :without_protection => true)
County.create!({:id => 175, :county_name => "Spotsylvania", :state_id => 47, :county_code=> "51177", :status => 0, :county_state_code => "VA177"}, :without_protection => true)
County.create!({:id => 176, :county_name => "Stafford", :state_id => 47, :county_code=> "51179", :status => 0, :county_state_code => "VA179"}, :without_protection => true)
County.create!({:id => 177, :county_name => "Staunton City", :state_id => 47, :county_code=> "51790", :status => 0, :county_state_code => "VA790"}, :without_protection => true)
County.create!({:id => 178, :county_name => "Suffolk City", :state_id => 47, :county_code=> "51800", :status => 0, :county_state_code => "VA800"}, :without_protection => true)
County.create!({:id => 179, :county_name => "Surry", :state_id => 47, :county_code=> "51181", :status => 0, :county_state_code => "VA181"}, :without_protection => true)
County.create!({:id => 180, :county_name => "Virginia Beach City", :state_id => 47, :county_code=> "51810", :status => 0, :county_state_code => "VA810"}, :without_protection => true)
County.create!({:id => 181, :county_name => "Warren", :state_id => 47, :county_code=> "51187", :status => 0, :county_state_code => "VA187"}, :without_protection => true)
County.create!({:id => 182, :county_name => "Waynesboro City", :state_id => 47, :county_code=> "51820", :status => 0, :county_state_code => "VA820"}, :without_protection => true)
County.create!({:id => 183, :county_name => "Westmoreland", :state_id => 47, :county_code=> "51193", :status => 0, :county_state_code => "VA193"}, :without_protection => true)
County.create!({:id => 184, :county_name => "Williamsburg City", :state_id => 47, :county_code=> "51830", :status => 0, :county_state_code => "VA830"}, :without_protection => true)
County.create!({:id => 185, :county_name => "Winchester City", :state_id => 47, :county_code=> "51840", :status => 0, :county_state_code => "VA840"}, :without_protection => true)
County.create!({:id => 186, :county_name => "York", :state_id => 47, :county_code=> "51199", :status => 0, :county_state_code => "VA199"}, :without_protection => true)
County.create!({:id => 187, :county_name => "Berkeley", :state_id => 49, :county_code=> "54003", :status => 0, :county_state_code => "WV003"}, :without_protection => true)
County.create!({:id => 188, :county_name => "Grant", :state_id => 49, :county_code=> "54023", :status => 0, :county_state_code => "WV023"}, :without_protection => true)
County.create!({:id => 189, :county_name => "Hampshire", :state_id => 49, :county_code=> "54027", :status => 0, :county_state_code => "WV027"}, :without_protection => true)
County.create!({:id => 190, :county_name => "Hardy", :state_id => 49, :county_code=> "54031", :status => 0, :county_state_code => "WV031"}, :without_protection => true)
County.create!({:id => 191, :county_name => "Jefferson", :state_id => 49, :county_code=> "54037", :status => 0, :county_state_code => "WV037"}, :without_protection => true)
County.create!({:id => 192, :county_name => "Mineral", :state_id => 49, :county_code=> "54057", :status => 0, :county_state_code => "WV057"}, :without_protection => true)
County.create!({:id => 193, :county_name => "Monroe", :state_id => 49, :county_code=> "54063", :status => 0, :county_state_code => "WV063"}, :without_protection => true)
County.create!({:id => 194, :county_name => "Morgan", :state_id => 49, :county_code=> "54065", :status => 0, :county_state_code => "WV065"}, :without_protection => true)
County.create!({:id => 195, :county_name => "Pendleton", :state_id => 49, :county_code=> "54071", :status => 0, :county_state_code => "WV071"}, :without_protection => true)
County.create!({:id => 196, :county_name => "Preston", :state_id => 49, :county_code=> "54077", :status => 0, :county_state_code => "WV077"}, :without_protection => true)
County.create!({:id => 197, :county_name => "Tucker", :state_id => 49, :county_code=> "54093", :status => 0, :county_state_code => "WV093"}, :without_protection => true)
