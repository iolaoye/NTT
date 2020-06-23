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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_26_145752) do

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.integer "code"
    t.string "abbreviation"
    t.string "spanish_name"
    t.integer "apex_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "amount_label"
    t.string "amount_units"
    t.string "depth_label"
    t.string "depth_units"
    t.integer "order"
  end

  create_table "animal_transports", force: :cascade do |t|
    t.integer "trip_number"
    t.integer "scenario_id"
    t.integer "freq_trip"
    t.boolean "cattle_pro"
    t.integer "purpose"
    t.integer "trans"
    t.integer "categories_trans"
    t.integer "categories_slaug"
    t.float "avg_marweight"
    t.float "mortality_rate"
    t.float "distance"
    t.string "trailer_id"
    t.integer "truck_id"
    t.string "fuel_id"
    t.boolean "same_vehicle"
    t.integer "loading"
    t.float "carcass"
    t.float "boneless_beef"
    t.integer "num_animal"
  end

  create_table "animals", force: :cascade do |t|
    t.string "name"
    t.boolean "status"
    t.integer "apex_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "dry_manure"
    t.float "no3n"
    t.float "po4p"
    t.float "orgn"
    t.float "orgp"
  end

  create_table "annual_results", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "sub1"
    t.integer "year"
    t.float "flow"
    t.float "qdr"
    t.float "surface_flow"
    t.float "sed"
    t.float "ymnu"
    t.float "orgp"
    t.float "po4"
    t.float "orgn"
    t.float "no3"
    t.float "qdrn"
    t.float "qdrp"
    t.float "qn"
    t.float "dprk"
    t.float "irri"
    t.float "pcp"
    t.float "n2o"
    t.float "prkn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "watershed_id"
    t.float "co2"
    t.float "biom"
  end

  create_table "apex_controls", force: :cascade do |t|
    t.integer "control_description_id"
    t.float "value"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apex_parameters", force: :cascade do |t|
    t.integer "parameter_description_id"
    t.float "value"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aplcat_parameters", force: :cascade do |t|
    t.integer "aplcat_param_id"
    t.integer "scenario_id"
    t.integer "noc"
    t.integer "nomb"
    t.integer "norh"
    t.float "abwc"
    t.float "abwmb"
    t.float "abwh"
    t.float "prh"
    t.float "prb"
    t.float "adwgbc"
    t.float "adwgbh"
    t.float "mrga"
    t.integer "jdcc"
    t.integer "gpc"
    t.float "tpwg"
    t.integer "csefa"
    t.float "srop"
    t.float "bwoc"
    t.integer "jdbs"
    t.float "dmd"
    t.float "dmi"
    t.float "napanr"
    t.float "napaip"
    t.float "mpsm"
    t.float "splm"
    t.float "pmme"
    t.float "rhaeba"
    t.float "toaboba"
    t.float "vsim"
    t.float "foue"
    t.float "ash"
    t.float "mmppfm"
    t.float "cfmms"
    t.float "fnemimms"
    t.float "effn2ofmms"
    t.float "dwawfga"
    t.float "dwawflc"
    t.float "dwawfmb"
    t.float "pgu"
    t.float "ada"
    t.float "ape"
    t.float "platc"
    t.float "pctbb"
    t.float "ptdife"
    t.integer "tnggbc"
    t.integer "mm_type"
    t.float "fmbmm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "n_tfa"
    t.float "n_sr"
    t.integer "n_arnfa"
    t.integer "n_arpfa"
    t.float "n_nfar"
    t.integer "n_npfar"
    t.float "n_co2enfa"
    t.integer "n_co2epfp"
    t.float "n_co2enfp"
    t.integer "n_lamf"
    t.integer "n_lan2of"
    t.float "n_laco2f"
    t.integer "n_socc"
    t.integer "i_tfa"
    t.float "i_sr"
    t.integer "i_arnfa"
    t.integer "i_arpfa"
    t.float "i_nfar"
    t.integer "i_npfar"
    t.float "i_co2enfa"
    t.integer "i_co2epfp"
    t.float "i_co2enfp"
    t.integer "i_lamf"
    t.integer "i_lan2of"
    t.float "i_laco2f"
    t.integer "i_socc"
    t.float "cpl_lowest"
    t.float "cpl_highest"
    t.float "tdn_lowest"
    t.float "tdn_highest"
    t.float "ndf_lowest"
    t.float "ndf_highest"
    t.float "adf_lowest"
    t.float "adf_highest"
    t.float "fir_lowest"
    t.float "fir_highest"
    t.float "theta"
    t.float "fge"
    t.float "fde"
    t.integer "first_area"
    t.integer "first_equip"
    t.integer "first_fuel"
    t.integer "second_area"
    t.integer "second_equip"
    t.integer "second_fuel"
    t.integer "third_area"
    t.integer "third_equip"
    t.integer "third_fuel"
    t.integer "fourth_area"
    t.integer "fourth_equip"
    t.integer "fourth_fuel"
    t.integer "fifth_area"
    t.integer "fifth_equip"
    t.integer "fifth_fuel"
    t.integer "trans_1"
    t.integer "categories_trans_1"
    t.float "categories_slaug_1"
    t.integer "avg_marweight_1"
    t.integer "num_animal_1"
    t.float "mortality_rate_1"
    t.float "distance_1"
    t.string "trailer_1"
    t.string "trucks_1"
    t.string "fuel_type_1"
    t.integer "same_vehicle_1"
    t.integer "loading_1"
    t.float "carcass_1"
    t.float "boneless_beef_1"
    t.integer "trans_2"
    t.integer "categories_trans_2"
    t.float "categories_slaug_2"
    t.integer "avg_marweight_2"
    t.integer "num_animal_2"
    t.float "mortality_rate_2"
    t.float "distance_2"
    t.string "trailer_2"
    t.string "trucks_2"
    t.string "fuel_type_2"
    t.integer "same_vehicle_2"
    t.integer "loading_2"
    t.float "carcass_2"
    t.float "boneless_beef_2"
    t.integer "trans_3"
    t.integer "categories_trans_3"
    t.float "categories_slaug_3"
    t.integer "avg_marweight_3"
    t.integer "num_animal_3"
    t.float "mortality_rate_3"
    t.float "distance_3"
    t.string "trailer_3"
    t.string "trucks_3"
    t.string "fuel_type_3"
    t.integer "same_vehicle_3"
    t.integer "loading_3"
    t.float "carcass_3"
    t.float "boneless_beef_3"
    t.integer "trans_4"
    t.integer "categories_trans_4"
    t.float "categories_slaug_4"
    t.integer "avg_marweight_4"
    t.integer "num_animal_4"
    t.float "mortality_rate_4"
    t.float "distance_4"
    t.string "trailer_4"
    t.string "trucks_4"
    t.string "fuel_type_4"
    t.integer "same_vehicle_4"
    t.integer "loading_4"
    t.float "carcass_4"
    t.float "boneless_beef_4"
    t.integer "second_avg_marweight_1"
    t.integer "second_num_animal_1"
    t.integer "second_avg_marweight_2"
    t.integer "second_num_animal_2"
    t.integer "second_avg_marweight_3"
    t.integer "second_num_animal_3"
    t.integer "second_avg_marweight_4"
    t.integer "second_num_animal_4"
    t.float "tjan"
    t.float "tfeb"
    t.float "tmar"
    t.float "tapr"
    t.float "tmay"
    t.float "tjun"
    t.float "tjul"
    t.float "taug"
    t.float "tsep"
    t.float "toct"
    t.float "tnov"
    t.float "tdec"
    t.float "hjan"
    t.float "hfeb"
    t.float "hmar"
    t.float "hapr"
    t.float "hjun"
    t.float "hmay"
    t.float "hjul"
    t.float "haug"
    t.float "hsep"
    t.float "hoct"
    t.float "hnov"
    t.float "hdec"
    t.integer "sixth_area"
    t.integer "sixth_equip"
    t.integer "sixth_fuel"
    t.integer "seventh_area"
    t.integer "seventh_equip"
    t.integer "seventh_fuel"
    t.integer "eighth_area"
    t.integer "eighth_equip"
    t.integer "eighth_fuel"
    t.integer "ninth_area"
    t.integer "ninth_equip"
    t.integer "ninth_fuel"
    t.integer "tenth_area"
    t.integer "tenth_equip"
    t.integer "tenth_fuel"
    t.integer "eleventh_area"
    t.integer "eleventh_equip"
    t.integer "eleventh_fuel"
    t.integer "twelveth_area"
    t.integer "twelveth_equip"
    t.integer "twelveth_fuel"
    t.integer "thirteen_area"
    t.integer "thirteen_equip"
    t.integer "thirteen_fuel"
    t.integer "fourteen_area"
    t.integer "fourteen_equip"
    t.integer "fourteen_fuel"
    t.integer "fifteen_area"
    t.integer "fifteen_equip"
    t.integer "fifteen_fuel"
    t.integer "sixteen_area"
    t.integer "sixteen_equip"
    t.integer "sixteen_fuel"
    t.integer "seventeen_area"
    t.integer "seventeen_equip"
    t.integer "seventeen_fuel"
    t.integer "eighteen_area"
    t.integer "eighteen_equip"
    t.integer "eighteen_fuel"
    t.integer "ninteen_area"
    t.integer "ninteen_equip"
    t.integer "ninteen_fuel"
    t.integer "twenty_area"
    t.integer "twenty_equip"
    t.integer "twenty_fuel"
    t.integer "byos"
    t.integer "eyos"
    t.integer "mm_type_but"
    t.string "running_drinking_water"
    t.string "running_complete_stocker"
    t.string "running_ghg"
    t.string "running_transportation"
    t.string "number_of_forage"
    t.boolean "forage"
    t.string "fuel_id"
    t.string "first_fuel_id"
    t.string "second_fuel_id"
    t.string "third_fuel_id"
    t.string "fourth_fuel_id"
    t.string "fifth_fuel_id"
    t.string "sixth_fuel_id"
    t.string "seventh_fuel_id"
    t.string "eighth_fuel_id"
    t.string "ninth_fuel_id"
    t.string "tenth_fuel_id"
    t.string "eleventh_fuel_id"
    t.string "twelveth_fuel_id"
    t.string "thirteen_fuel_id"
    t.string "fourteen_fuel_id"
    t.string "fifteen_fuel_id"
    t.string "sixteen_fuel_id"
    t.string "seventeen_fuel_id"
    t.string "eighteen_fuel_id"
    t.string "ninteen_fuel_id"
    t.string "twenty_fuel_id"
  end

  create_table "aplcat_results", force: :cascade do |t|
    t.string "month_id"
    t.string "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "calf_aws"
    t.float "calf_dmi"
    t.float "calf_gei"
    t.float "calf_wi"
    t.float "calf_sme"
    t.float "calf_ni"
    t.float "calf_tne"
    t.float "calf_tnr"
    t.float "calf_fne"
    t.float "calf_une"
    t.float "calf_eme"
    t.float "calf_mme"
    t.float "rh_aws"
    t.float "rh_dmi"
    t.float "rh_gei"
    t.float "rh_wi"
    t.float "rh_sme"
    t.float "rh_ni"
    t.float "rh_tne"
    t.float "rh_tnr"
    t.float "rh_fne"
    t.float "rh_une"
    t.float "rh_eme"
    t.float "rh_mme"
    t.float "fch_aws"
    t.float "fch_dmi"
    t.float "fch_gei"
    t.float "fch_wi"
    t.float "fch_sme"
    t.float "fch_ni"
    t.float "fch_tne"
    t.float "fch_tnr"
    t.float "fch_fne"
    t.float "fch_une"
    t.float "fch_eme"
    t.float "fch_mme"
    t.float "cow_aws"
    t.float "cow_dmi"
    t.float "cow_gei"
    t.float "cow_wi"
    t.float "cow_sme"
    t.float "cow_ni"
    t.float "cow_tne"
    t.float "cow_tnr"
    t.float "cow_fne"
    t.float "cow_une"
    t.float "cow_eme"
    t.float "cow_mme"
    t.float "bull_aws"
    t.float "bull_dmi"
    t.float "bull_gei"
    t.float "bull_wi"
    t.float "bull_sme"
    t.float "bull_ni"
    t.float "bull_tne"
    t.float "bull_tnr"
    t.float "bull_fne"
    t.float "bull_une"
    t.float "bull_eme"
    t.float "bull_mme"
    t.integer "scenario_id"
  end

  create_table "bmplists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.string "spanish_name"
  end

  create_table "bmps", force: :cascade do |t|
    t.integer "bmp_id"
    t.integer "scenario_id"
    t.integer "crop_id"
    t.integer "irrigation_id"
    t.float "water_stress_factor"
    t.float "irrigation_efficiency"
    t.float "maximum_single_application"
    t.float "safety_factor"
    t.float "depth"
    t.float "area"
    t.integer "number_of_animals"
    t.integer "days"
    t.integer "hours"
    t.integer "animal_id"
    t.float "dry_manure"
    t.float "no3_n"
    t.float "po4_p"
    t.float "org_n"
    t.float "org_p"
    t.float "width"
    t.float "grass_field_portion"
    t.float "buffer_slope_upland"
    t.float "crop_width"
    t.float "slope_reduction"
    t.integer "sides"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "bmpsublist_id"
    t.float "difference_max_temperature"
    t.float "difference_min_temperature"
    t.float "difference_precipitation"
  end

  create_table "bmpsublists", force: :cascade do |t|
    t.string "name"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bmplist_id"
    t.string "spanish_name"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "animal_transport_id"
    t.float "weight"
    t.integer "animals"
  end

  create_table "charts", force: :cascade do |t|
    t.integer "description_id"
    t.integer "watershed_id"
    t.integer "scenario_id"
    t.integer "field_id"
    t.integer "soil_id"
    t.integer "month_year"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "crop_id"
  end

  create_table "climates", force: :cascade do |t|
    t.integer "bmp_id"
    t.float "max_temp"
    t.float "min_temp"
    t.float "precipitation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "month"
  end

  create_table "climes", force: :cascade do |t|
    t.integer "field_id"
    t.string "daily_weather"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "issue_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "control_descriptions", force: :cascade do |t|
    t.integer "control_desc_id"
    t.integer "line"
    t.integer "column"
    t.string "code"
    t.string "name"
    t.float "range_low"
    t.float "range_high"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "controls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "default_value"
    t.integer "state_id"
    t.integer "number"
  end

  create_table "counties", force: :cascade do |t|
    t.string "county_name"
    t.string "county_code"
    t.integer "status"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "county_state_code"
    t.integer "wind_wp1_code"
    t.string "wind_wp1_name"
  end

  create_table "crop_results", force: :cascade do |t|
    t.integer "scenario_id"
    t.string "name"
    t.integer "sub1"
    t.integer "year"
    t.float "yldg"
    t.float "yldf"
    t.float "ws"
    t.float "ns"
    t.float "ps"
    t.float "ts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "watershed_id"
  end

  create_table "crop_schedules", force: :cascade do |t|
    t.integer "crop_schedule_id"
    t.string "name"
    t.string "state_id"
    t.integer "class_id"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cropping_systems", force: :cascade do |t|
    t.string "name"
    t.string "crop"
    t.string "tillage"
    t.string "var12"
    t.string "state_id"
    t.boolean "grazing"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crops", force: :cascade do |t|
    t.integer "number"
    t.integer "dndc"
    t.string "code"
    t.string "name"
    t.float "plant_population_mt"
    t.float "plant_population_ac"
    t.float "plant_population_ft"
    t.float "heat_units"
    t.integer "lu_number"
    t.integer "soil_group_a"
    t.integer "soil_group_b"
    t.integer "soil_group_c"
    t.integer "soil_group_d"
    t.string "type1"
    t.string "yield_unit"
    t.float "bushel_weight"
    t.float "conversion_factor"
    t.float "dry_matter"
    t.integer "harvest_code"
    t.integer "planting_code"
    t.string "state_id"
    t.float "itil"
    t.float "to1"
    t.float "tb"
    t.integer "dd"
    t.integer "dyam"
    t.string "spanish_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "descriptions", force: :cascade do |t|
    t.boolean "detail"
    t.string "description"
    t.string "spanish_description"
    t.string "unit"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "period"
    t.integer "order_id"
    t.integer "group_id"
  end

  create_table "drainages", force: :cascade do |t|
    t.integer "drainage_id"
    t.string "name"
    t.integer "wtmx"
    t.integer "wtmn"
    t.integer "wtbl"
    t.integer "zqt"
    t.integer "ztk"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "event_order"
    t.integer "month"
    t.integer "day"
    t.integer "year"
    t.integer "activity_id"
    t.integer "apex_operation"
    t.integer "apex_crop"
    t.integer "apex_fertilizer"
    t.float "apex_opv1"
    t.float "apex_opv2"
    t.integer "cropping_system_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facility_augmenteds", force: :cascade do |t|
    t.string "name"
    t.float "lease_rate"
    t.float "new_price"
    t.float "current_price"
    t.integer "life_remaining"
    t.float "maintenance_coeff"
    t.float "loan_interest_rate"
    t.float "length_loan"
    t.float "interest_rate_equity"
    t.float "proportion_debt"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "farm_generals", force: :cascade do |t|
    t.string "name"
    t.integer "values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feeds_augmenteds", force: :cascade do |t|
    t.string "name"
    t.float "selling_price"
    t.float "purchase_price"
    t.integer "concentrate"
    t.integer "forage"
    t.integer "grain"
    t.integer "hay"
    t.integer "pasture"
    t.integer "silage"
    t.integer "supplement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fem_facilities", force: :cascade do |t|
    t.string "name"
    t.float "lease_rate"
    t.float "new_price"
    t.float "new_life"
    t.float "current_price"
    t.integer "life_remaining"
    t.float "maintenance_coeff"
    t.float "loan_interest_rate"
    t.float "length_loan"
    t.float "interest_rate_equity"
    t.float "proportion_debt"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "codes"
    t.integer "ownership"
    t.boolean "updated"
  end

  create_table "fem_feeds", force: :cascade do |t|
    t.string "name"
    t.float "selling_price"
    t.float "purchase_price"
    t.float "concentrate"
    t.float "forage"
    t.float "grain"
    t.float "hay"
    t.float "pasture"
    t.float "silage"
    t.float "supplement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "codes"
    t.integer "ownership"
    t.boolean "updated"
  end

  create_table "fem_generals", force: :cascade do |t|
    t.string "name"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "codes"
    t.integer "ownership"
    t.boolean "updated"
  end

  create_table "fem_machines", force: :cascade do |t|
    t.string "name"
    t.float "lease_rate"
    t.float "new_price"
    t.integer "new_hours"
    t.float "current_price"
    t.integer "hours_remaining"
    t.float "width"
    t.float "speed"
    t.float "field_efficiency"
    t.float "horse_power"
    t.float "rf1"
    t.float "rf2"
    t.float "ir_loan"
    t.float "l_loan"
    t.float "ir_equity"
    t.float "p_debt"
    t.integer "year"
    t.float "rv1"
    t.float "rv2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "codes"
    t.integer "ownership"
    t.boolean "updated"
  end

  create_table "fem_results", force: :cascade do |t|
    t.float "total_revenue"
    t.float "total_cost"
    t.float "net_return"
    t.float "net_cash_flow"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "scenario_id"
    t.integer "watershed_id"
  end

  create_table "fertilizer_types", force: :cascade do |t|
    t.string "name"
    t.string "spanish_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fertilizers", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.float "qn"
    t.float "qp"
    t.float "yn"
    t.float "yp"
    t.float "nh3"
    t.float "dry_matter"
    t.integer "fertilizer_type_id"
    t.float "convertion_unit"
    t.boolean "status"
    t.boolean "animal"
    t.string "spanish_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_n"
    t.float "total_p"
  end

  create_table "fields", force: :cascade do |t|
    t.integer "location_id"
    t.string "field_name"
    t.float "field_area"
    t.float "field_average_slope"
    t.boolean "field_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "coordinates", limit: 16777215
    t.integer "weather_id"
    t.float "soilp"
    t.boolean "updated"
    t.float "soil_aliminum"
  end

  create_table "fuels", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grazing_parameters", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "code"
    t.integer "starting_julian_day"
    t.integer "ending_julian_day"
    t.integer "dmi_code"
    t.float "dmi_cows"
    t.float "dmi_bulls"
    t.float "dmi_heifers"
    t.float "dmi_calves"
    t.float "dmi_rheifers"
    t.float "green_water_footprint"
    t.float "for_dmi_cows"
    t.float "for_dmi_bulls"
    t.float "for_dmi_heifers"
    t.float "for_dmi_calves"
    t.float "for_dmi_rheifers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "green_water_footprint_supplement"
    t.integer "for_button"
    t.integer "supplement_button"
  end

  create_table "groups", force: :cascade do |t|
    t.string "group_name"
    t.string "spanish_group_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "importances", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "irrigations", force: :cascade do |t|
    t.string "name"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "spanish_name"
    t.integer "code"
  end

  create_table "issues", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "comment_id"
    t.date "expected_data"
    t.date "close_date"
    t.integer "status_id"
    t.integer "user_id"
    t.integer "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority_id"
    t.integer "developer_id"
  end

  create_table "layers", force: :cascade do |t|
    t.float "depth"
    t.float "soil_p"
    t.float "bulk_density"
    t.float "sand"
    t.float "silt"
    t.float "clay"
    t.float "organic_matter"
    t.float "ph"
    t.integer "soil_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "uw"
    t.float "fc"
    t.float "wn"
    t.float "smb"
    t.float "woc"
    t.float "cac"
    t.float "cec"
    t.float "rok"
    t.float "cnds"
    t.float "rsd"
    t.float "bdd"
    t.float "psp"
    t.float "satc"
    t.integer "soil_test_id"
    t.float "soil_p_initial"
    t.float "soil_aluminum"
  end

  create_table "locations", force: :cascade do |t|
    t.integer "state_id"
    t.integer "county_id"
    t.string "status"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "coordinates"
  end

  create_table "machine_augmenteds", force: :cascade do |t|
    t.string "name"
    t.float "lease_rate"
    t.float "new_price"
    t.integer "new_hours"
    t.float "current_price"
    t.integer "hours_remaining"
    t.float "width"
    t.float "speed"
    t.float "field_efficiency"
    t.float "horse_power"
    t.float "rf1"
    t.float "rf2"
    t.float "ir_loan"
    t.float "l_loan"
    t.float "ir_equity"
    t.float "p_debt"
    t.integer "year"
    t.float "rv1"
    t.float "rv2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manure_controls", force: :cascade do |t|
    t.integer "manure_control_id"
    t.string "name"
    t.string "spanish_name"
    t.float "no3n"
    t.float "po4p"
    t.float "orgn"
    t.float "orgp"
    t.float "om"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operations", force: :cascade do |t|
    t.integer "crop_id"
    t.integer "activity_id"
    t.integer "day"
    t.integer "month_id"
    t.integer "year"
    t.integer "type_id"
    t.float "amount"
    t.float "depth"
    t.float "no3_n"
    t.float "po4_p"
    t.float "org_n"
    t.float "org_p"
    t.float "nh3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "scenario_id"
    t.integer "subtype_id"
    t.float "moisture"
    t.float "org_c"
    t.float "nh4_n"
    t.integer "rotation"
  end

  create_table "parameter_descriptions", force: :cascade do |t|
    t.integer "parameter_desc_id"
    t.integer "line"
    t.integer "number"
    t.string "name"
    t.float "range_low"
    t.float "range_high"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parameters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "default_value"
    t.integer "state_id"
    t.integer "number"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer "watershed_id"
    t.integer "field_id"
    t.integer "soil_id"
    t.integer "scenario_id"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "ci_value"
    t.integer "description_id"
    t.integer "crop_id"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "field_id"
    t.datetime "last_simulation"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "event_order"
    t.integer "month"
    t.integer "day"
    t.integer "year"
    t.integer "activity_id"
    t.integer "apex_operation"
    t.integer "apex_crop"
    t.integer "apex_fertilizer"
    t.float "apex_opv1"
    t.float "apex_opv2"
    t.integer "crop_schedule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", force: :cascade do |t|
    t.float "ylat"
    t.float "xlog"
    t.float "elev"
    t.float "apm"
    t.float "co2x"
    t.float "cqnx"
    t.float "rfnx"
    t.float "upr"
    t.float "unr"
    t.float "fir0"
    t.integer "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "soil_operations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.integer "operation_id"
    t.integer "tractor_id"
    t.integer "apex_crop"
    t.integer "type_id"
    t.float "opv1"
    t.float "opv2"
    t.float "opv3"
    t.float "opv4"
    t.float "opv5"
    t.float "opv6"
    t.float "opv7"
    t.integer "scenario_id"
    t.integer "soil_id"
    t.integer "activity_id"
    t.integer "apex_operation"
    t.integer "bmp_id"
  end

  create_table "soils", force: :cascade do |t|
    t.boolean "selected"
    t.string "key"
    t.string "symbol"
    t.string "group"
    t.string "name"
    t.float "albedo"
    t.float "slope"
    t.float "percentage"
    t.integer "field_id"
    t.integer "drainage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "ffc"
    t.float "wtmn"
    t.float "wtmx"
    t.float "wtbl"
    t.float "gwst"
    t.float "gwmx"
    t.float "rft"
    t.float "rfpk"
    t.float "tsla"
    t.float "xids"
    t.float "rtn1"
    t.float "xidk"
    t.float "zqt"
    t.float "zf"
    t.float "ztk"
    t.float "fbm"
    t.float "fhp"
    t.integer "soil_id_old"
  end

  create_table "states", force: :cascade do |t|
    t.string "state_name"
    t.string "state_code"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state_abbreviation"
  end

  create_table "stations", force: :cascade do |t|
    t.integer "initial_year"
    t.integer "final_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "lat"
    t.float "lon"
    t.string "file_name"
  end

  create_table "statuses", force: :cascade do |t|
    t.integer "issue_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subareas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "soil_id"
    t.integer "bmp_id"
    t.integer "scenario_id"
    t.string "subarea_type"
    t.string "description"
    t.integer "number"
    t.integer "inps"
    t.integer "iops"
    t.integer "iow"
    t.integer "ii"
    t.integer "iapl"
    t.integer "nvcn"
    t.integer "iwth"
    t.integer "ipts"
    t.integer "isao"
    t.integer "luns"
    t.integer "imw"
    t.float "sno"
    t.float "stdo"
    t.float "yct"
    t.float "xct"
    t.float "azm"
    t.float "fl"
    t.float "fw"
    t.float "angl"
    t.float "wsa"
    t.float "chl"
    t.float "chd"
    t.float "chs"
    t.float "chn"
    t.float "slp"
    t.float "splg"
    t.float "upn"
    t.float "ffpq"
    t.float "urbf"
    t.float "rchl"
    t.float "rchd"
    t.float "rcbw"
    t.float "rctw"
    t.float "rchs"
    t.float "rchn"
    t.float "rchc"
    t.float "rchk"
    t.float "rfpw"
    t.float "rfpl"
    t.float "rsee"
    t.float "rsae"
    t.float "rsve"
    t.float "rsep"
    t.float "rsap"
    t.float "rsvp"
    t.float "rsv"
    t.float "rsrr"
    t.float "rsys"
    t.float "rsyn"
    t.float "rshc"
    t.float "rsdp"
    t.float "rsbd"
    t.float "pcof"
    t.float "bcof"
    t.float "bffl"
    t.integer "nirr"
    t.integer "iri"
    t.integer "ira"
    t.integer "lm"
    t.integer "ifd"
    t.integer "idr"
    t.integer "idf1"
    t.integer "idf2"
    t.integer "idf3"
    t.integer "idf4"
    t.integer "idf5"
    t.float "bir"
    t.float "efi"
    t.float "vimx"
    t.float "armn"
    t.float "armx"
    t.float "bft"
    t.float "fnp4"
    t.float "fmx"
    t.float "drt"
    t.float "fdsf"
    t.float "pec"
    t.float "dalg"
    t.float "vlgn"
    t.float "coww"
    t.float "ddlg"
    t.float "solq"
    t.float "sflg"
    t.float "fnp2"
    t.float "fnp5"
    t.float "firg"
    t.integer "ny1"
    t.integer "ny2"
    t.integer "ny3"
    t.integer "ny4"
    t.integer "ny5"
    t.integer "ny6"
    t.integer "ny7"
    t.integer "ny8"
    t.integer "ny9"
    t.integer "ny10"
    t.integer "xtp1"
    t.integer "xtp2"
    t.integer "xtp3"
    t.integer "xtp4"
    t.integer "xtp5"
    t.integer "xtp6"
    t.integer "xtp7"
    t.integer "xtp8"
    t.integer "xtp9"
    t.integer "xtp10"
    t.integer "tdms"
  end

  create_table "supplement_parameters", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "code"
    t.integer "dmi_code"
    t.float "dmi_cows"
    t.float "dmi_bulls"
    t.float "dmi_heifers"
    t.float "dmi_calves"
    t.integer "green_water_footprint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "dmi_rheifers"
    t.integer "starting_julian_day"
    t.integer "ending_julian_day"
    t.float "for_dmi_cows"
    t.float "for_dmi_bulls"
    t.float "for_dmi_calves"
    t.float "for_dmi_heifers"
    t.float "for_dmi_rheifers"
    t.float "green_water_footprint_supplement"
    t.integer "for_button"
    t.integer "supplement_button"
  end

  create_table "tillages", force: :cascade do |t|
    t.string "name"
    t.integer "code"
    t.string "abbreviation"
    t.string "spanish_name"
    t.integer "operation"
    t.integer "dndc"
    t.string "eqp"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "activity_id"
  end

  create_table "trailers", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "length"
    t.string "width"
    t.string "payload"
    t.string "suggestion"
    t.string "height"
  end

  create_table "trucks", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "types", force: :cascade do |t|
    t.integer "issue_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "hashed_password"
    t.string "name"
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "reset_token"
  end

  create_table "watershed_scenarios", force: :cascade do |t|
    t.integer "watershed_id"
    t.integer "field_id"
    t.integer "scenario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "field_id_to"
  end

  create_table "watersheds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.datetime "last_simulation"
  end

  create_table "ways", force: :cascade do |t|
    t.string "way_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "spanish_name"
    t.string "way_value"
  end

  create_table "weathers", force: :cascade do |t|
    t.integer "field_id"
    t.integer "station_id"
    t.string "station_way"
    t.integer "simulation_initial_year"
    t.integer "simulation_final_year"
    t.float "longitude"
    t.float "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weather_file"
    t.integer "way_id"
    t.integer "weather_initial_year"
    t.integer "weather_final_year"
  end

end
