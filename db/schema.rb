# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160513165033) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.string   "abbreviation"
    t.string   "spanish_name"
    t.integer  "apex_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "animals", :force => true do |t|
    t.string   "name"
    t.boolean  "status"
    t.integer  "apex_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bmplists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "status"
    t.string   "spanish_name"
  end

  create_table "bmps", :force => true do |t|
    t.integer  "bmp_id"
    t.integer  "scenario_id"
    t.integer  "crop_id"
    t.integer  "irrigation_id"
    t.float    "water_stress_factor"
    t.float    "irrigation_efficiency"
    t.float    "maximum_single_application"
    t.float    "safety_factor"
    t.float    "depth"
    t.float    "area"
    t.integer  "number_of_animals"
    t.integer  "days"
    t.integer  "hours"
    t.integer  "animal_id"
    t.float    "dry_manure"
    t.float    "no3_n"
    t.float    "po4_p"
    t.float    "org_n"
    t.float    "org_p"
    t.float    "width"
    t.float    "grass_field_portion"
    t.float    "buffer_slope_upland"
    t.float    "crop_width"
    t.float    "slope_reduction"
    t.integer  "sides"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "name"
    t.integer  "bmpsublist_id"
    t.float    "difference_max_temperature"
    t.float    "difference_min_temperature"
    t.float    "difference_precipitation"
  end

  create_table "bmpsublists", :force => true do |t|
    t.string   "name"
    t.boolean  "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "bmplist_id"
    t.string   "spanish_name"
  end

  create_table "controls", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "line"
    t.integer  "column"
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.float    "range_low"
    t.float    "range_high"
    t.float    "default_value"
  end

  create_table "counties", :force => true do |t|
    t.string   "county_name"
    t.string   "county_code"
    t.integer  "status"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "state_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "county_state_code"
  end

  create_table "cropping_systems", :force => true do |t|
    t.string   "name"
    t.string   "crop"
    t.string   "tillage"
    t.string   "var12"
    t.string   "state_id"
    t.boolean  "grazing"
    t.boolean  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "crops", :force => true do |t|
    t.integer  "number"
    t.integer  "dndc"
    t.string   "code"
    t.string   "name"
    t.float    "plant_population_mt"
    t.float    "plant_population_ac"
    t.float    "plant_population_ft"
    t.float    "heat_units"
    t.integer  "lu_number"
    t.integer  "soil_group_a"
    t.integer  "soil_group_b"
    t.integer  "soil_group_c"
    t.integer  "soil_group_d"
    t.string   "type1"
    t.string   "yield_unit"
    t.float    "bushel_weight"
    t.float    "conversion_factor"
    t.float    "dry_matter"
    t.integer  "harvest_code"
    t.integer  "planting_code"
    t.string   "state_id"
    t.float    "itil"
    t.float    "to1"
    t.float    "tb"
    t.integer  "dd"
    t.integer  "dyam"
    t.string   "spanish_name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "fertilizer_types", :force => true do |t|
    t.string   "name"
    t.string   "spanish_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "fertilizers", :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.float    "qn"
    t.float    "qp"
    t.float    "yn"
    t.float    "yp"
    t.float    "nh3"
    t.float    "dry_matter"
    t.integer  "fertilizer_type_id"
    t.float    "convertion_unit"
    t.boolean  "status"
    t.boolean  "animal"
    t.string   "spanish_name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "fields", :force => true do |t|
    t.integer  "location_id"
    t.string   "field_name"
    t.float    "field_area"
    t.float    "field_average_slope"
    t.boolean  "field_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "coordinates"
    t.integer  "weather_id"
  end

  create_table "irrigations", :force => true do |t|
    t.string   "name"
    t.boolean  "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "spanish_name"
    t.integer  "code"
  end

  create_table "layers", :force => true do |t|
    t.float    "depth"
    t.float    "soil_p"
    t.float    "bulk_density"
    t.float    "sand"
    t.float    "silt"
    t.float    "clay"
    t.float    "organic_matter"
    t.float    "ph"
    t.integer  "soil_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.float    "uw"
    t.float    "fc"
    t.float    "wn"
    t.float    "smb"
    t.float    "woc"
    t.float    "cac"
    t.float    "cec"
    t.float    "rok"
    t.float    "cnds"
    t.float    "rsd"
    t.float    "bdd"
    t.float    "psp"
    t.float    "satc"
  end

  create_table "locations", :force => true do |t|
    t.integer  "state_id"
    t.integer  "county_id"
    t.string   "status"
    t.integer  "project_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "coordinates"
  end

  create_table "modifications", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "operations", :force => true do |t|
    t.integer  "crop_id"
    t.integer  "activity_id"
    t.integer  "day"
    t.integer  "month_id"
    t.integer  "year"
    t.integer  "type_id"
    t.float    "amount"
    t.float    "depth"
    t.float    "no3_n"
    t.float    "po4_p"
    t.float    "org_n"
    t.float    "org_p"
    t.float    "nh3"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "scenario_id"
    t.integer  "subtype_id"
  end

  create_table "parameters", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "line"
    t.integer  "number"
    t.string   "name"
    t.string   "description"
    t.float    "range_low"
    t.float    "range_high"
    t.float    "default_value"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "version"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "field_id"
  end

  create_table "simulations", :force => true do |t|
    t.integer  "type_id"
    t.string   "field_id"
    t.string   "subproject_id"
    t.integer  "scenario_id"
    t.boolean  "project"
    t.boolean  "location"
    t.boolean  "weather"
    t.boolean  "fields"
    t.boolean  "soils"
    t.boolean  "layers"
    t.boolean  "management"
    t.string   "las_simulation"
    t.string   "comments"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "sites", :force => true do |t|
    t.float    "ylat"
    t.float    "xlog"
    t.float    "elev"
    t.float    "apm"
    t.float    "co2x"
    t.float    "cqnx"
    t.float    "rfnx"
    t.float    "upr"
    t.float    "unr"
    t.float    "fir0"
    t.integer  "field_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "soil_operations", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.integer  "operation_id"
    t.integer  "tractor_id"
    t.integer  "apex_crop"
    t.integer  "type_id"
    t.float    "opv1"
    t.float    "opv2"
    t.float    "opv3"
    t.float    "opv4"
    t.float    "opv5"
    t.float    "opv6"
    t.float    "opv7"
    t.integer  "scenario_id"
    t.integer  "soil_id"
    t.integer  "activity_id"
    t.integer  "apex_operation"
  end

  create_table "soils", :force => true do |t|
    t.boolean  "selected"
    t.string   "key"
    t.string   "symbol"
    t.string   "group"
    t.string   "name"
    t.float    "albedo"
    t.float    "slope"
    t.float    "percentage"
    t.integer  "field_id"
    t.string   "drainage_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.float    "ffc"
    t.float    "wtmn"
    t.float    "wtmx"
    t.float    "wtbl"
    t.float    "gwst"
    t.float    "gwmx"
    t.float    "rft"
    t.float    "rfpk"
    t.float    "tsla"
    t.float    "xids"
    t.float    "rtn1"
    t.float    "xidk"
    t.float    "zqt"
    t.float    "zf"
    t.float    "ztk"
    t.float    "fbm"
    t.float    "fhp"
  end

  create_table "states", :force => true do |t|
    t.string   "state_name"
    t.string   "state_code"
    t.integer  "status"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "state_abbreviation"
  end

  create_table "stations", :force => true do |t|
    t.integer  "county_id"
    t.string   "station_name"
    t.string   "station_code"
    t.string   "station_type"
    t.boolean  "station_status"
    t.integer  "wind_code"
    t.integer  "wp1_code"
    t.string   "wind_name"
    t.string   "wp1_name"
    t.integer  "initial_year"
    t.integer  "final_year"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "subareas", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "soil_id"
    t.integer  "bmp_id"
    t.integer  "scenario_id"
    t.string   "type"
    t.string   "description"
    t.integer  "number"
    t.integer  "inps"
    t.integer  "iops"
    t.integer  "iow"
    t.integer  "ii"
    t.integer  "iapl"
    t.integer  "nvcn"
    t.integer  "iwth"
    t.integer  "ipts"
    t.integer  "isao"
    t.integer  "luns"
    t.integer  "imw"
    t.float    "sno"
    t.float    "stdo"
    t.float    "yct"
    t.float    "xct"
    t.float    "azm"
    t.float    "fl"
    t.float    "fw"
    t.float    "angl"
    t.float    "wsa"
    t.float    "chl"
    t.float    "chd"
    t.float    "chs"
    t.float    "chn"
    t.float    "slp"
    t.float    "splg"
    t.float    "upn"
    t.float    "ffpq"
    t.float    "urbf"
    t.float    "rchl"
    t.float    "rchd"
    t.float    "rcbw"
    t.float    "rctw"
    t.float    "rchs"
    t.float    "rchn"
    t.float    "rchc"
    t.float    "rchk"
    t.float    "rfpw"
    t.float    "rfpl"
    t.float    "rsee"
    t.float    "rsae"
    t.float    "rsve"
    t.float    "rsep"
    t.float    "rsap"
    t.float    "rsvp"
    t.float    "rsv"
    t.float    "rsrr"
    t.float    "rsys"
    t.float    "rsyn"
    t.float    "rshc"
    t.float    "rsdp"
    t.float    "rsbd"
    t.float    "pcof"
    t.float    "bcof"
    t.float    "bffl"
    t.integer  "nirr"
    t.integer  "iri"
    t.integer  "ira"
    t.integer  "lm"
    t.integer  "ifd"
    t.integer  "idr"
    t.integer  "idf1"
    t.integer  "idf2"
    t.integer  "idf3"
    t.integer  "idf4"
    t.integer  "idf5"
    t.float    "bir"
    t.float    "efi"
    t.float    "vimx"
    t.float    "armn"
    t.float    "armx"
    t.float    "bft"
    t.float    "fnp4"
    t.float    "fmx"
    t.float    "drt"
    t.float    "fdsf"
    t.float    "pec"
    t.float    "dalg"
    t.float    "vlgn"
    t.float    "coww"
    t.float    "ddlg"
    t.float    "solq"
    t.float    "sflg"
    t.float    "fnp2"
    t.float    "fnp5"
    t.float    "firg"
    t.integer  "ny1"
    t.integer  "ny2"
    t.integer  "ny3"
    t.integer  "ny4"
    t.integer  "ny5"
    t.integer  "ny6"
    t.integer  "ny7"
    t.integer  "ny8"
    t.integer  "ny9"
    t.integer  "ny10"
    t.integer  "xtp1"
    t.integer  "xtp2"
    t.integer  "xtp3"
    t.integer  "xtp4"
    t.integer  "xtp5"
    t.integer  "xtp6"
    t.integer  "xtp7"
    t.integer  "xtp8"
    t.integer  "xtp9"
    t.integer  "xtp10"
  end

  create_table "tillages", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.string   "abbreviation"
    t.string   "spanish_name"
    t.integer  "operation"
    t.integer  "dndc"
    t.string   "eqp"
    t.boolean  "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "activity_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "name"
    t.string   "company"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "ways", :force => true do |t|
    t.string   "way_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "spanish_name"
    t.string   "way_value"
  end

  create_table "weathers", :force => true do |t|
    t.integer  "field_id"
    t.integer  "station_id"
    t.string   "station_way"
    t.integer  "simulation_initial_year"
    t.integer  "simulation_final_year"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "weather_file"
    t.integer  "way_id"
    t.integer  "weather_initial_year"
    t.integer  "weather_final_year"
  end

end
