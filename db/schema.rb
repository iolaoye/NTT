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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181008203917) do

  create_table "activities", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "code",         limit: 4
    t.string   "abbreviation", limit: 255
    t.string   "spanish_name", limit: 255
    t.integer  "apex_code",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "amount_label", limit: 255
    t.string   "amount_units", limit: 255
    t.string   "depth_label",  limit: 255
    t.string   "depth_units",  limit: 255
  end

  create_table "animals", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "status"
    t.integer  "apex_code",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "annual_results", force: :cascade do |t|
    t.integer  "scenario_id",  limit: 4
    t.integer  "sub1",         limit: 4
    t.integer  "year",         limit: 4
    t.float    "flow",         limit: 24
    t.float    "qdr",          limit: 24
    t.float    "surface_flow", limit: 24
    t.float    "sed",          limit: 24
    t.float    "ymnu",         limit: 24
    t.float    "orgp",         limit: 24
    t.float    "po4",          limit: 24
    t.float    "orgn",         limit: 24
    t.float    "no3",          limit: 24
    t.float    "qdrn",         limit: 24
    t.float    "qdrp",         limit: 24
    t.float    "qn",           limit: 24
    t.float    "dprk",         limit: 24
    t.float    "irri",         limit: 24
    t.float    "pcp",          limit: 24
    t.float    "n2o",          limit: 24
    t.float    "prkn",         limit: 24
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "watershed_id", limit: 4
    t.float    "co2",          limit: 24
  end

  create_table "apex_controls", force: :cascade do |t|
    t.integer  "control_description_id", limit: 4
    t.float    "value",                  limit: 24
    t.integer  "project_id",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apex_parameters", force: :cascade do |t|
    t.integer  "parameter_description_id", limit: 4
    t.float    "value",                    limit: 24
    t.integer  "project_id",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aplcat_parameters", force: :cascade do |t|
    t.integer  "aplcat_param_id",        limit: 4
    t.integer  "scenario_id",            limit: 4
    t.integer  "noc",                    limit: 4
    t.integer  "nomb",                   limit: 4
    t.integer  "norh",                   limit: 4
    t.float    "abwc",                   limit: 24
    t.float    "abwmb",                  limit: 24
    t.float    "abwh",                   limit: 24
    t.float    "prh",                    limit: 24
    t.float    "prb",                    limit: 24
    t.float    "adwgbc",                 limit: 24
    t.float    "adwgbh",                 limit: 24
    t.float    "mrga",                   limit: 24
    t.integer  "jdcc",                   limit: 4
    t.integer  "gpc",                    limit: 4
    t.float    "tpwg",                   limit: 24
    t.integer  "csefa",                  limit: 4
    t.float    "srop",                   limit: 24
    t.float    "bwoc",                   limit: 24
    t.integer  "jdbs",                   limit: 4
    t.float    "dmd",                    limit: 24
    t.float    "dmi",                    limit: 24
    t.float    "napanr",                 limit: 24
    t.float    "napaip",                 limit: 24
    t.float    "mpsm",                   limit: 24
    t.float    "splm",                   limit: 24
    t.float    "pmme",                   limit: 24
    t.float    "rhaeba",                 limit: 24
    t.float    "toaboba",                limit: 24
    t.float    "vsim",                   limit: 24
    t.float    "foue",                   limit: 24
    t.float    "ash",                    limit: 24
    t.float    "mmppfm",                 limit: 24
    t.float    "cfmms",                  limit: 24
    t.float    "fnemimms",               limit: 24
    t.float    "effn2ofmms",             limit: 24
    t.float    "dwawfga",                limit: 24
    t.float    "dwawflc",                limit: 24
    t.float    "dwawfmb",                limit: 24
    t.float    "pgu",                    limit: 24
    t.float    "ada",                    limit: 24
    t.float    "ape",                    limit: 24
    t.float    "platc",                  limit: 24
    t.float    "pctbb",                  limit: 24
    t.float    "ptdife",                 limit: 24
    t.integer  "tnggbc",                 limit: 4
    t.integer  "mm_type",                limit: 4
    t.float    "fmbmm",                  limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "abwrh",                  limit: 24
    t.integer  "nocrh",                  limit: 4
    t.integer  "abc",                    limit: 4
    t.integer  "forage_id",              limit: 4
    t.integer  "jincrease",              limit: 4
    t.integer  "stabilization",          limit: 4
    t.integer  "decline",                limit: 4
    t.integer  "opt4",                   limit: 4
    t.float    "crude_low",              limit: 24
    t.float    "crude_high",             limit: 24
    t.float    "tdn_low",                limit: 24
    t.float    "tdn_high",               limit: 24
    t.float    "ndf_low",                limit: 24
    t.float    "ndf_high",               limit: 24
    t.float    "adf_low",                limit: 24
    t.float    "adf_high",               limit: 24
    t.float    "feed_low",               limit: 24
    t.float    "feed_high",              limit: 24
    t.integer  "tripn",                  limit: 4
    t.integer  "freqtrip",               limit: 4
    t.string   "filedetails",            limit: 255
    t.integer  "cattlepro",              limit: 4
    t.string   "purpose",                limit: 255
    t.integer  "codepurpose",            limit: 4
    t.integer  "mdogfc",                 limit: 4
    t.integer  "mxdogfc",                limit: 4
    t.integer  "cwsoj",                  limit: 4
    t.integer  "cweoj",                  limit: 4
    t.integer  "ewc",                    limit: 4
    t.integer  "nodew",                  limit: 4
    t.integer  "byosm",                  limit: 4
    t.integer  "eyosm",                  limit: 4
    t.float    "mrgauh",                 limit: 24
    t.integer  "plac",                   limit: 4
    t.integer  "pcbb",                   limit: 4
    t.integer  "domd",                   limit: 4
    t.float    "faueea",                 limit: 24
    t.float    "acim",                   limit: 24
    t.float    "mmppm",                  limit: 24
    t.float    "cffm",                   limit: 24
    t.float    "fnemm",                  limit: 24
    t.float    "effd",                   limit: 24
    t.float    "ptbd",                   limit: 24
    t.float    "pocib",                  limit: 24
    t.float    "bneap",                  limit: 24
    t.float    "cneap",                  limit: 24
    t.float    "hneap",                  limit: 24
    t.float    "pobw",                   limit: 24
    t.float    "posw",                   limit: 24
    t.float    "posb",                   limit: 24
    t.float    "poad",                   limit: 24
    t.float    "poada",                  limit: 24
    t.float    "cibo",                   limit: 24
    t.float    "drinkg",                 limit: 24
    t.float    "drinkl",                 limit: 24
    t.float    "drinkm",                 limit: 24
    t.float    "avgtm",                  limit: 24
    t.float    "avghm",                  limit: 24
    t.float    "rhae",                   limit: 24
    t.float    "tabo",                   limit: 24
    t.float    "mpism",                  limit: 24
    t.float    "spilm",                  limit: 24
    t.float    "pom",                    limit: 24
    t.float    "srinr",                  limit: 24
    t.float    "sriip",                  limit: 24
    t.float    "pogu",                   limit: 24
    t.float    "adoa",                   limit: 24
    t.integer  "n_tfa",                  limit: 4
    t.float    "n_sr",                   limit: 24
    t.integer  "n_arnfa",                limit: 4
    t.integer  "n_arpfa",                limit: 4
    t.float    "n_nfar",                 limit: 24
    t.integer  "n_npfar",                limit: 4
    t.float    "n_co2enfa",              limit: 24
    t.integer  "n_co2epfp",              limit: 4
    t.float    "n_co2enfp",              limit: 24
    t.integer  "n_lamf",                 limit: 4
    t.integer  "n_lan2of",               limit: 4
    t.float    "n_laco2f",               limit: 24
    t.integer  "n_socc",                 limit: 4
    t.integer  "i_tfa",                  limit: 4
    t.float    "i_sr",                   limit: 24
    t.integer  "i_arnfa",                limit: 4
    t.integer  "i_arpfa",                limit: 4
    t.float    "i_nfar",                 limit: 24
    t.integer  "i_npfar",                limit: 4
    t.float    "i_co2enfa",              limit: 24
    t.integer  "i_co2epfp",              limit: 4
    t.float    "i_co2enfp",              limit: 24
    t.integer  "i_lamf",                 limit: 4
    t.integer  "i_lan2of",               limit: 4
    t.float    "i_laco2f",               limit: 24
    t.integer  "i_socc",                 limit: 4
    t.float    "cpl_lowest",             limit: 24
    t.float    "cpl_highest",            limit: 24
    t.float    "tdn_lowest",             limit: 24
    t.float    "tdn_highest",            limit: 24
    t.float    "ndf_lowest",             limit: 24
    t.float    "ndf_highest",            limit: 24
    t.float    "adf_lowest",             limit: 24
    t.float    "adf_highest",            limit: 24
    t.float    "fir_lowest",             limit: 24
    t.float    "fir_highest",            limit: 24
    t.float    "theta",                  limit: 24
    t.float    "fge",                    limit: 24
    t.float    "fde",                    limit: 24
    t.integer  "first_area",             limit: 4
    t.integer  "first_equip",            limit: 4
    t.integer  "first_fuel",             limit: 4
    t.integer  "second_area",            limit: 4
    t.integer  "second_equip",           limit: 4
    t.integer  "second_fuel",            limit: 4
    t.integer  "third_area",             limit: 4
    t.integer  "third_equip",            limit: 4
    t.integer  "third_fuel",             limit: 4
    t.integer  "fourth_area",            limit: 4
    t.integer  "fourth_equip",           limit: 4
    t.integer  "fourth_fuel",            limit: 4
    t.integer  "fifth_area",             limit: 4
    t.integer  "fifth_equip",            limit: 4
    t.integer  "fifth_fuel",             limit: 4
    t.integer  "trans_1",                limit: 4
    t.integer  "categories_trans_1",     limit: 4
    t.float    "categories_slaug_1",     limit: 24
    t.integer  "avg_marweight_1",        limit: 4
    t.integer  "num_animal_1",           limit: 4
    t.float    "mortality_rate_1",       limit: 24
    t.float    "distance_1",             limit: 24
    t.string   "trailer_1",              limit: 255
    t.string   "trucks_1",               limit: 255
    t.string   "fuel_type_1",            limit: 255
    t.integer  "same_vehicle_1",         limit: 4
    t.integer  "loading_1",              limit: 4
    t.float    "carcass_1",              limit: 24
    t.float    "boneless_beef_1",        limit: 24
    t.integer  "trans_2",                limit: 4
    t.integer  "categories_trans_2",     limit: 4
    t.float    "categories_slaug_2",     limit: 24
    t.integer  "avg_marweight_2",        limit: 4
    t.integer  "num_animal_2",           limit: 4
    t.float    "mortality_rate_2",       limit: 24
    t.float    "distance_2",             limit: 24
    t.string   "trailer_2",              limit: 255
    t.string   "trucks_2",               limit: 255
    t.string   "fuel_type_2",            limit: 255
    t.integer  "same_vehicle_2",         limit: 4
    t.integer  "loading_2",              limit: 4
    t.float    "carcass_2",              limit: 24
    t.float    "boneless_beef_2",        limit: 24
    t.integer  "trans_3",                limit: 4
    t.integer  "categories_trans_3",     limit: 4
    t.float    "categories_slaug_3",     limit: 24
    t.integer  "avg_marweight_3",        limit: 4
    t.integer  "num_animal_3",           limit: 4
    t.float    "mortality_rate_3",       limit: 24
    t.float    "distance_3",             limit: 24
    t.string   "trailer_3",              limit: 255
    t.string   "trucks_3",               limit: 255
    t.string   "fuel_type_3",            limit: 255
    t.integer  "same_vehicle_3",         limit: 4
    t.integer  "loading_3",              limit: 4
    t.float    "carcass_3",              limit: 24
    t.float    "boneless_beef_3",        limit: 24
    t.integer  "trans_4",                limit: 4
    t.integer  "categories_trans_4",     limit: 4
    t.float    "categories_slaug_4",     limit: 24
    t.integer  "avg_marweight_4",        limit: 4
    t.integer  "num_animal_4",           limit: 4
    t.float    "mortality_rate_4",       limit: 24
    t.float    "distance_4",             limit: 24
    t.string   "trailer_4",              limit: 255
    t.string   "trucks_4",               limit: 255
    t.string   "fuel_type_4",            limit: 255
    t.integer  "same_vehicle_4",         limit: 4
    t.integer  "loading_4",              limit: 4
    t.float    "carcass_4",              limit: 24
    t.float    "boneless_beef_4",        limit: 24
    t.integer  "second_avg_marweight_1", limit: 4
    t.integer  "second_num_animal_1",    limit: 4
    t.integer  "second_avg_marweight_2", limit: 4
    t.integer  "second_num_animal_2",    limit: 4
    t.integer  "second_avg_marweight_3", limit: 4
    t.integer  "second_num_animal_3",    limit: 4
    t.integer  "second_avg_marweight_4", limit: 4
    t.integer  "second_num_animal_4",    limit: 4
    t.float    "tjan",                   limit: 24
    t.float    "tfeb",                   limit: 24
    t.float    "tmar",                   limit: 24
    t.float    "tapr",                   limit: 24
    t.float    "tmay",                   limit: 24
    t.float    "tjun",                   limit: 24
    t.float    "tjul",                   limit: 24
    t.float    "taug",                   limit: 24
    t.float    "tsep",                   limit: 24
    t.float    "toct",                   limit: 24
    t.float    "tnov",                   limit: 24
    t.float    "tdec",                   limit: 24
    t.float    "hjan",                   limit: 24
    t.float    "hfeb",                   limit: 24
    t.float    "hmar",                   limit: 24
    t.float    "hapr",                   limit: 24
    t.float    "hjun",                   limit: 24
    t.float    "hmay",                   limit: 24
    t.float    "hjul",                   limit: 24
    t.float    "haug",                   limit: 24
    t.float    "hsep",                   limit: 24
    t.float    "hoct",                   limit: 24
    t.float    "hnov",                   limit: 24
    t.float    "hdec",                   limit: 24
  end

  create_table "aplcat_results", force: :cascade do |t|
    t.string   "month_id",   limit: 255
    t.string   "option_id",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.float    "calf_aws",   limit: 24
    t.float    "calf_dmi",   limit: 24
    t.float    "calf_gei",   limit: 24
    t.float    "calf_wi",    limit: 24
    t.float    "calf_sme",   limit: 24
    t.float    "calf_ni",    limit: 24
    t.float    "calf_tne",   limit: 24
    t.float    "calf_tnr",   limit: 24
    t.float    "calf_fne",   limit: 24
    t.float    "calf_une",   limit: 24
    t.float    "calf_eme",   limit: 24
    t.float    "calf_mme",   limit: 24
    t.float    "rh_aws",     limit: 24
    t.float    "rh_dmi",     limit: 24
    t.float    "rh_gei",     limit: 24
    t.float    "rh_wi",      limit: 24
    t.float    "rh_sme",     limit: 24
    t.float    "rh_ni",      limit: 24
    t.float    "rh_tne",     limit: 24
    t.float    "rh_tnr",     limit: 24
    t.float    "rh_fne",     limit: 24
    t.float    "rh_une",     limit: 24
    t.float    "rh_eme",     limit: 24
    t.float    "rh_mme",     limit: 24
    t.float    "fch_aws",    limit: 24
    t.float    "fch_dmi",    limit: 24
    t.float    "fch_gei",    limit: 24
    t.float    "fch_wi",     limit: 24
    t.float    "fch_sme",    limit: 24
    t.float    "fch_ni",     limit: 24
    t.float    "fch_tne",    limit: 24
    t.float    "fch_tnr",    limit: 24
    t.float    "fch_fne",    limit: 24
    t.float    "fch_une",    limit: 24
    t.float    "fch_eme",    limit: 24
    t.float    "fch_mme",    limit: 24
    t.float    "cow_aws",    limit: 24
    t.float    "cow_dmi",    limit: 24
    t.float    "cow_gei",    limit: 24
    t.float    "cow_wi",     limit: 24
    t.float    "cow_sme",    limit: 24
    t.float    "cow_ni",     limit: 24
    t.float    "cow_tne",    limit: 24
    t.float    "cow_tnr",    limit: 24
    t.float    "cow_fne",    limit: 24
    t.float    "cow_une",    limit: 24
    t.float    "cow_eme",    limit: 24
    t.float    "cow_mme",    limit: 24
    t.float    "bull_aws",   limit: 24
    t.float    "bull_dmi",   limit: 24
    t.float    "bull_gei",   limit: 24
    t.float    "bull_wi",    limit: 24
    t.float    "bull_sme",   limit: 24
    t.float    "bull_ni",    limit: 24
    t.float    "bull_tne",   limit: 24
    t.float    "bull_tnr",   limit: 24
    t.float    "bull_fne",   limit: 24
    t.float    "bull_une",   limit: 24
    t.float    "bull_eme",   limit: 24
    t.float    "bull_mme",   limit: 24
  end

  create_table "bmplists", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status"
    t.string   "spanish_name", limit: 255
  end

  create_table "bmps", force: :cascade do |t|
    t.integer  "bmp_id",                     limit: 4
    t.integer  "scenario_id",                limit: 4
    t.integer  "crop_id",                    limit: 4
    t.integer  "irrigation_id",              limit: 4
    t.float    "water_stress_factor",        limit: 24
    t.float    "irrigation_efficiency",      limit: 24
    t.float    "maximum_single_application", limit: 24
    t.float    "safety_factor",              limit: 24
    t.float    "depth",                      limit: 24
    t.float    "area",                       limit: 24
    t.integer  "number_of_animals",          limit: 4
    t.integer  "days",                       limit: 4
    t.integer  "hours",                      limit: 4
    t.integer  "animal_id",                  limit: 4
    t.float    "dry_manure",                 limit: 24
    t.float    "no3_n",                      limit: 24
    t.float    "po4_p",                      limit: 24
    t.float    "org_n",                      limit: 24
    t.float    "org_p",                      limit: 24
    t.float    "width",                      limit: 24
    t.float    "grass_field_portion",        limit: 24
    t.float    "buffer_slope_upland",        limit: 24
    t.float    "crop_width",                 limit: 24
    t.float    "slope_reduction",            limit: 24
    t.integer  "sides",                      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                       limit: 255
    t.integer  "bmpsublist_id",              limit: 4
    t.float    "difference_max_temperature", limit: 24
    t.float    "difference_min_temperature", limit: 24
    t.float    "difference_precipitation",   limit: 24
  end

  create_table "bmpsublists", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bmplist_id",   limit: 4
    t.string   "spanish_name", limit: 255
  end

  create_table "charts", force: :cascade do |t|
    t.integer  "description_id", limit: 4
    t.integer  "watershed_id",   limit: 4
    t.integer  "scenario_id",    limit: 4
    t.integer  "field_id",       limit: 4
    t.integer  "soil_id",        limit: 4
    t.integer  "month_year",     limit: 4
    t.float    "value",          limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crop_id",        limit: 4
  end

  create_table "climates", force: :cascade do |t|
    t.integer  "bmp_id",        limit: 4
    t.float    "max_temp",      limit: 24
    t.float    "min_temp",      limit: 24
    t.float    "precipitation", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "month",         limit: 4
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "issue_id",    limit: 4
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "control_descriptions", force: :cascade do |t|
    t.integer  "control_desc_id", limit: 4
    t.integer  "line",            limit: 4
    t.integer  "column",          limit: 4
    t.string   "code",            limit: 255
    t.string   "name",            limit: 255
    t.float    "range_low",       limit: 24
    t.float    "range_high",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "controls", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "default_value", limit: 24
    t.integer  "state_id",      limit: 4
    t.integer  "number",        limit: 4
  end

  create_table "counties", force: :cascade do |t|
    t.string   "county_name",       limit: 255
    t.string   "county_code",       limit: 255
    t.integer  "status",            limit: 4
    t.integer  "state_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county_state_code", limit: 255
    t.integer  "wind_wp1_code",     limit: 4
    t.string   "wind_wp1_name",     limit: 255
  end

  create_table "crop_results", force: :cascade do |t|
    t.integer  "scenario_id",  limit: 4
    t.string   "name",         limit: 255
    t.integer  "sub1",         limit: 4
    t.integer  "year",         limit: 4
    t.float    "yldg",         limit: 24
    t.float    "yldf",         limit: 24
    t.float    "ws",           limit: 24
    t.float    "ns",           limit: 24
    t.float    "ps",           limit: 24
    t.float    "ts",           limit: 24
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "watershed_id", limit: 4
  end

  create_table "crop_schedules", force: :cascade do |t|
    t.integer  "crop_schedule_id", limit: 4
    t.string   "name",             limit: 255
    t.string   "state_id",         limit: 255
    t.integer  "class_id",         limit: 4
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cropping_systems", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "crop",       limit: 255
    t.string   "tillage",    limit: 255
    t.string   "var12",      limit: 255
    t.string   "state_id",   limit: 255
    t.boolean  "grazing"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crops", force: :cascade do |t|
    t.integer  "number",              limit: 4
    t.integer  "dndc",                limit: 4
    t.string   "code",                limit: 255
    t.string   "name",                limit: 255
    t.float    "plant_population_mt", limit: 24
    t.float    "plant_population_ac", limit: 24
    t.float    "plant_population_ft", limit: 24
    t.float    "heat_units",          limit: 24
    t.integer  "lu_number",           limit: 4
    t.integer  "soil_group_a",        limit: 4
    t.integer  "soil_group_b",        limit: 4
    t.integer  "soil_group_c",        limit: 4
    t.integer  "soil_group_d",        limit: 4
    t.string   "type1",               limit: 255
    t.string   "yield_unit",          limit: 255
    t.float    "bushel_weight",       limit: 24
    t.float    "conversion_factor",   limit: 24
    t.float    "dry_matter",          limit: 24
    t.integer  "harvest_code",        limit: 4
    t.integer  "planting_code",       limit: 4
    t.string   "state_id",            limit: 255
    t.float    "itil",                limit: 24
    t.float    "to1",                 limit: 24
    t.float    "tb",                  limit: 24
    t.integer  "dd",                  limit: 4
    t.integer  "dyam",                limit: 4
    t.string   "spanish_name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions", force: :cascade do |t|
    t.boolean  "detail"
    t.string   "description",         limit: 255
    t.string   "spanish_description", limit: 255
    t.string   "unit",                limit: 255
    t.integer  "position",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "period",              limit: 4
    t.integer  "order_id",            limit: 4
    t.integer  "group_id",            limit: 4
  end

  create_table "drainages", force: :cascade do |t|
    t.integer  "drainage_id", limit: 4
    t.string   "name",        limit: 255
    t.integer  "wtmx",        limit: 4
    t.integer  "wtmn",        limit: 4
    t.integer  "wtbl",        limit: 4
    t.integer  "zqt",         limit: 4
    t.integer  "ztk",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "event_order",        limit: 4
    t.integer  "month",              limit: 4
    t.integer  "day",                limit: 4
    t.integer  "year",               limit: 4
    t.integer  "activity_id",        limit: 4
    t.integer  "apex_operation",     limit: 4
    t.integer  "apex_crop",          limit: 4
    t.integer  "apex_fertilizer",    limit: 4
    t.float    "apex_opv1",          limit: 24
    t.float    "apex_opv2",          limit: 24
    t.integer  "cropping_system_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facility_augmenteds", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.float    "lease_rate",           limit: 24
    t.float    "new_price",            limit: 24
    t.float    "current_price",        limit: 24
    t.integer  "life_remaining",       limit: 4
    t.float    "maintenance_coeff",    limit: 24
    t.float    "loan_interest_rate",   limit: 24
    t.float    "length_loan",          limit: 24
    t.float    "interest_rate_equity", limit: 24
    t.float    "proportion_debt",      limit: 24
    t.integer  "year",                 limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "farm_generals", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "values",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "feeds_augmenteds", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.float    "selling_price",  limit: 24
    t.float    "purchase_price", limit: 24
    t.integer  "concentrate",    limit: 4
    t.integer  "forage",         limit: 4
    t.integer  "grain",          limit: 4
    t.integer  "hay",            limit: 4
    t.integer  "pasture",        limit: 4
    t.integer  "silage",         limit: 4
    t.integer  "supplement",     limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "fertilizer_types", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "spanish_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fertilizers", force: :cascade do |t|
    t.integer  "code",               limit: 4
    t.string   "name",               limit: 255
    t.float    "qn",                 limit: 24
    t.float    "qp",                 limit: 24
    t.float    "yn",                 limit: 24
    t.float    "yp",                 limit: 24
    t.float    "nh3",                limit: 24
    t.float    "dry_matter",         limit: 24
    t.integer  "fertilizer_type_id", limit: 4
    t.float    "convertion_unit",    limit: 24
    t.boolean  "status"
    t.boolean  "animal"
    t.string   "spanish_name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total_n",            limit: 24
    t.float    "total_p",            limit: 24
  end

  create_table "fields", force: :cascade do |t|
    t.integer  "location_id",         limit: 4
    t.string   "field_name",          limit: 255
    t.float    "field_area",          limit: 24
    t.float    "field_average_slope", limit: 24
    t.boolean  "field_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "coordinates",         limit: 16777215
    t.integer  "weather_id",          limit: 4
    t.float    "soilp",               limit: 24
    t.boolean  "updated"
    t.integer  "soil_test",           limit: 4
    t.float    "soil_aliminum",       limit: 24
  end

  create_table "grazing_parameters", force: :cascade do |t|
    t.integer  "scenario_id",                      limit: 4
    t.integer  "code",                             limit: 4
    t.integer  "starting_julian_day",              limit: 4
    t.integer  "ending_julian_day",                limit: 4
    t.integer  "dmi_code",                         limit: 4
    t.float    "dmi_cows",                         limit: 24
    t.float    "dmi_bulls",                        limit: 24
    t.float    "dmi_heifers",                      limit: 24
    t.float    "dmi_calves",                       limit: 24
    t.float    "green_water_footprint",            limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "green_water_footprint_supplement", limit: 24
    t.float    "for_dmi_cows",                     limit: 24
    t.float    "for_dmi_bulls",                    limit: 24
    t.float    "for_dmi_heifers",                  limit: 24
    t.float    "for_dmi_calves",                   limit: 24
    t.float    "for_dmi_rheifers",                 limit: 24
    t.float    "dmi_rheifers",                     limit: 24
    t.integer  "for_button",                       limit: 4
    t.integer  "supplement_button",                limit: 4
  end

  create_table "groups", force: :cascade do |t|
    t.string   "group_name",         limit: 255
    t.string   "spanish_group_name", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "importances", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "irrigations", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spanish_name", limit: 255
    t.integer  "code",         limit: 4
  end

  create_table "issues", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "description",   limit: 65535
    t.integer  "comment_id",    limit: 4
    t.date     "expected_data"
    t.date     "close_date"
    t.integer  "status_id",     limit: 4
    t.integer  "user_id",       limit: 4
    t.integer  "type_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "priority_id",   limit: 4
    t.integer  "developer_id",  limit: 4
  end

  create_table "layers", force: :cascade do |t|
    t.float    "depth",          limit: 24
    t.float    "soil_p",         limit: 24
    t.float    "bulk_density",   limit: 24
    t.float    "sand",           limit: 24
    t.float    "silt",           limit: 24
    t.float    "clay",           limit: 24
    t.float    "organic_matter", limit: 24
    t.float    "ph",             limit: 24
    t.integer  "soil_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "uw",             limit: 24
    t.float    "fc",             limit: 24
    t.float    "wn",             limit: 24
    t.float    "smb",            limit: 24
    t.float    "woc",            limit: 24
    t.float    "cac",            limit: 24
    t.float    "cec",            limit: 24
    t.float    "rok",            limit: 24
    t.float    "cnds",           limit: 24
    t.float    "rsd",            limit: 24
    t.float    "bdd",            limit: 24
    t.float    "psp",            limit: 24
    t.float    "satc",           limit: 24
    t.integer  "soil_test_id",   limit: 4
    t.float    "soil_p_initial", limit: 24
    t.float    "soil_aluminum",  limit: 24
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "state_id",    limit: 4
    t.integer  "county_id",   limit: 4
    t.string   "status",      limit: 255
    t.integer  "project_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "coordinates", limit: 65535
  end

  create_table "manure_controls", force: :cascade do |t|
    t.integer  "manure_control_id", limit: 4
    t.string   "name",              limit: 255
    t.string   "spanish_name",      limit: 255
    t.float    "no3n",              limit: 24
    t.float    "po4p",              limit: 24
    t.float    "orgn",              limit: 24
    t.float    "orgp",              limit: 24
    t.float    "om",                limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modifications", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operations", force: :cascade do |t|
    t.integer  "crop_id",     limit: 4
    t.integer  "activity_id", limit: 4
    t.integer  "day",         limit: 4
    t.integer  "month_id",    limit: 4
    t.integer  "year",        limit: 4
    t.integer  "type_id",     limit: 4
    t.float    "amount",      limit: 24
    t.float    "depth",       limit: 24
    t.float    "no3_n",       limit: 24
    t.float    "po4_p",       limit: 24
    t.float    "org_n",       limit: 24
    t.float    "org_p",       limit: 24
    t.float    "nh3",         limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scenario_id", limit: 4
    t.integer  "subtype_id",  limit: 4
    t.float    "moisture",    limit: 24
    t.float    "org_c",       limit: 24
    t.float    "nh4_n",       limit: 24
    t.integer  "rotation",    limit: 4
  end

  create_table "parameter_descriptions", force: :cascade do |t|
    t.integer  "parameter_desc_id", limit: 4
    t.integer  "line",              limit: 4
    t.integer  "number",            limit: 4
    t.string   "name",              limit: 255
    t.float    "range_low",         limit: 24
    t.float    "range_high",        limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parameters", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "default_value", limit: 24
    t.integer  "state_id",      limit: 4
    t.integer  "number",        limit: 4
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "age",        limit: 4
    t.string   "last_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priorities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "version",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",     limit: 4
  end

  create_table "results", force: :cascade do |t|
    t.integer  "watershed_id",   limit: 4
    t.integer  "field_id",       limit: 4
    t.integer  "soil_id",        limit: 4
    t.integer  "scenario_id",    limit: 4
    t.float    "value",          limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ci_value",       limit: 24
    t.integer  "description_id", limit: 4
    t.integer  "crop_id",        limit: 4
  end

  create_table "scenarios", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field_id",        limit: 4
    t.datetime "last_simulation"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "schedule_id",      limit: 4
    t.integer  "event_order",      limit: 4
    t.integer  "month",            limit: 4
    t.integer  "day",              limit: 4
    t.integer  "year",             limit: 4
    t.integer  "activity_id",      limit: 4
    t.integer  "apex_operation",   limit: 4
    t.integer  "apex_crop",        limit: 4
    t.integer  "apex_fertilizer",  limit: 4
    t.float    "apex_opv1",        limit: 24
    t.float    "apex_opv2",        limit: 24
    t.integer  "crop_schedule_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: :cascade do |t|
    t.float    "ylat",       limit: 24
    t.float    "xlog",       limit: 24
    t.float    "elev",       limit: 24
    t.float    "apm",        limit: 24
    t.float    "co2x",       limit: 24
    t.float    "cqnx",       limit: 24
    t.float    "rfnx",       limit: 24
    t.float    "upr",        limit: 24
    t.float    "unr",        limit: 24
    t.float    "fir0",       limit: 24
    t.integer  "field_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "soil_operations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year",           limit: 4
    t.integer  "month",          limit: 4
    t.integer  "day",            limit: 4
    t.integer  "operation_id",   limit: 4
    t.integer  "tractor_id",     limit: 4
    t.integer  "apex_crop",      limit: 4
    t.integer  "type_id",        limit: 4
    t.float    "opv1",           limit: 24
    t.float    "opv2",           limit: 24
    t.float    "opv3",           limit: 24
    t.float    "opv4",           limit: 24
    t.float    "opv5",           limit: 24
    t.float    "opv6",           limit: 24
    t.float    "opv7",           limit: 24
    t.integer  "scenario_id",    limit: 4
    t.integer  "soil_id",        limit: 4
    t.integer  "activity_id",    limit: 4
    t.integer  "apex_operation", limit: 4
    t.integer  "bmp_id",         limit: 4
  end

  create_table "soil_tests", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.float    "factor1",    limit: 24
    t.float    "factor2",    limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "soils", force: :cascade do |t|
    t.boolean  "selected"
    t.string   "key",         limit: 255
    t.string   "symbol",      limit: 255
    t.string   "group",       limit: 255
    t.string   "name",        limit: 255
    t.float    "albedo",      limit: 24
    t.float    "slope",       limit: 24
    t.float    "percentage",  limit: 24
    t.integer  "field_id",    limit: 4
    t.integer  "drainage_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ffc",         limit: 24
    t.float    "wtmn",        limit: 24
    t.float    "wtmx",        limit: 24
    t.float    "wtbl",        limit: 24
    t.float    "gwst",        limit: 24
    t.float    "gwmx",        limit: 24
    t.float    "rft",         limit: 24
    t.float    "rfpk",        limit: 24
    t.float    "tsla",        limit: 24
    t.float    "xids",        limit: 24
    t.float    "rtn1",        limit: 24
    t.float    "xidk",        limit: 24
    t.float    "zqt",         limit: 24
    t.float    "zf",          limit: 24
    t.float    "ztk",         limit: 24
    t.float    "fbm",         limit: 24
    t.float    "fhp",         limit: 24
    t.integer  "soil_id_old", limit: 4
  end

  create_table "states", force: :cascade do |t|
    t.string   "state_name",         limit: 255
    t.string   "state_code",         limit: 255
    t.integer  "status",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_abbreviation", limit: 255
  end

  create_table "stations", force: :cascade do |t|
    t.integer  "county_id",      limit: 4
    t.string   "station_name",   limit: 255
    t.string   "station_code",   limit: 255
    t.string   "station_type",   limit: 255
    t.boolean  "station_status"
    t.integer  "wind_code",      limit: 4
    t.integer  "wp1_code",       limit: 4
    t.string   "wind_name",      limit: 255
    t.string   "wp1_name",       limit: 255
    t.integer  "initial_year",   limit: 4
    t.integer  "final_year",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", force: :cascade do |t|
    t.integer  "issue_id",   limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "subareas", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "soil_id",      limit: 4
    t.integer  "bmp_id",       limit: 4
    t.integer  "scenario_id",  limit: 4
    t.string   "subarea_type", limit: 255
    t.string   "description",  limit: 255
    t.integer  "number",       limit: 4
    t.integer  "inps",         limit: 4
    t.integer  "iops",         limit: 4
    t.integer  "iow",          limit: 4
    t.integer  "ii",           limit: 4
    t.integer  "iapl",         limit: 4
    t.integer  "nvcn",         limit: 4
    t.integer  "iwth",         limit: 4
    t.integer  "ipts",         limit: 4
    t.integer  "isao",         limit: 4
    t.integer  "luns",         limit: 4
    t.integer  "imw",          limit: 4
    t.float    "sno",          limit: 24
    t.float    "stdo",         limit: 24
    t.float    "yct",          limit: 24
    t.float    "xct",          limit: 24
    t.float    "azm",          limit: 24
    t.float    "fl",           limit: 24
    t.float    "fw",           limit: 24
    t.float    "angl",         limit: 24
    t.float    "wsa",          limit: 24
    t.float    "chl",          limit: 24
    t.float    "chd",          limit: 24
    t.float    "chs",          limit: 24
    t.float    "chn",          limit: 24
    t.float    "slp",          limit: 24
    t.float    "splg",         limit: 24
    t.float    "upn",          limit: 24
    t.float    "ffpq",         limit: 24
    t.float    "urbf",         limit: 24
    t.float    "rchl",         limit: 24
    t.float    "rchd",         limit: 24
    t.float    "rcbw",         limit: 24
    t.float    "rctw",         limit: 24
    t.float    "rchs",         limit: 24
    t.float    "rchn",         limit: 24
    t.float    "rchc",         limit: 24
    t.float    "rchk",         limit: 24
    t.float    "rfpw",         limit: 24
    t.float    "rfpl",         limit: 24
    t.float    "rsee",         limit: 24
    t.float    "rsae",         limit: 24
    t.float    "rsve",         limit: 24
    t.float    "rsep",         limit: 24
    t.float    "rsap",         limit: 24
    t.float    "rsvp",         limit: 24
    t.float    "rsv",          limit: 24
    t.float    "rsrr",         limit: 24
    t.float    "rsys",         limit: 24
    t.float    "rsyn",         limit: 24
    t.float    "rshc",         limit: 24
    t.float    "rsdp",         limit: 24
    t.float    "rsbd",         limit: 24
    t.float    "pcof",         limit: 24
    t.float    "bcof",         limit: 24
    t.float    "bffl",         limit: 24
    t.integer  "nirr",         limit: 4
    t.integer  "iri",          limit: 4
    t.integer  "ira",          limit: 4
    t.integer  "lm",           limit: 4
    t.integer  "ifd",          limit: 4
    t.integer  "idr",          limit: 4
    t.integer  "idf1",         limit: 4
    t.integer  "idf2",         limit: 4
    t.integer  "idf3",         limit: 4
    t.integer  "idf4",         limit: 4
    t.integer  "idf5",         limit: 4
    t.float    "bir",          limit: 24
    t.float    "efi",          limit: 24
    t.float    "vimx",         limit: 24
    t.float    "armn",         limit: 24
    t.float    "armx",         limit: 24
    t.float    "bft",          limit: 24
    t.float    "fnp4",         limit: 24
    t.float    "fmx",          limit: 24
    t.float    "drt",          limit: 24
    t.float    "fdsf",         limit: 24
    t.float    "pec",          limit: 24
    t.float    "dalg",         limit: 24
    t.float    "vlgn",         limit: 24
    t.float    "coww",         limit: 24
    t.float    "ddlg",         limit: 24
    t.float    "solq",         limit: 24
    t.float    "sflg",         limit: 24
    t.float    "fnp2",         limit: 24
    t.float    "fnp5",         limit: 24
    t.float    "firg",         limit: 24
    t.integer  "ny1",          limit: 4
    t.integer  "ny2",          limit: 4
    t.integer  "ny3",          limit: 4
    t.integer  "ny4",          limit: 4
    t.integer  "ny5",          limit: 4
    t.integer  "ny6",          limit: 4
    t.integer  "ny7",          limit: 4
    t.integer  "ny8",          limit: 4
    t.integer  "ny9",          limit: 4
    t.integer  "ny10",         limit: 4
    t.integer  "xtp1",         limit: 4
    t.integer  "xtp2",         limit: 4
    t.integer  "xtp3",         limit: 4
    t.integer  "xtp4",         limit: 4
    t.integer  "xtp5",         limit: 4
    t.integer  "xtp6",         limit: 4
    t.integer  "xtp7",         limit: 4
    t.integer  "xtp8",         limit: 4
    t.integer  "xtp9",         limit: 4
    t.integer  "xtp10",        limit: 4
  end

  create_table "supplement_parameters", force: :cascade do |t|
    t.integer  "scenario_id",                      limit: 4
    t.integer  "code",                             limit: 4
    t.integer  "dmi_code",                         limit: 4
    t.float    "dmi_cows",                         limit: 24
    t.float    "dmi_bulls",                        limit: 24
    t.float    "dmi_heifers",                      limit: 24
    t.float    "dmi_calves",                       limit: 24
    t.integer  "green_water_footprint",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "dmi_rheifers",                     limit: 24
    t.integer  "starting_julian_day",              limit: 4
    t.integer  "ending_julian_day",                limit: 4
    t.float    "for_dmi_cows",                     limit: 24
    t.float    "for_dmi_bulls",                    limit: 24
    t.float    "for_dmi_calves",                   limit: 24
    t.float    "for_dmi_heifers",                  limit: 24
    t.float    "for_dmi_rheifers",                 limit: 24
    t.float    "green_water_footprint_supplement", limit: 24
    t.integer  "for_button",                       limit: 4
    t.integer  "supplement_button",                limit: 4
  end

  create_table "tillages", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "code",         limit: 4
    t.string   "abbreviation", limit: 255
    t.string   "spanish_name", limit: 255
    t.integer  "operation",    limit: 4
    t.integer  "dndc",         limit: 4
    t.string   "eqp",          limit: 255
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id",  limit: 4
  end

  create_table "types", force: :cascade do |t|
    t.integer  "issue_id",   limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "hashed_password", limit: 255
    t.string   "name",            limit: 255
    t.string   "company",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "reset_digest",    limit: 255
    t.datetime "reset_sent_at"
    t.string   "reset_token",     limit: 255
  end

  create_table "watershed_scenarios", force: :cascade do |t|
    t.integer  "watershed_id", limit: 4
    t.integer  "field_id",     limit: 4
    t.integer  "scenario_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watersheds", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id",     limit: 4
    t.datetime "last_simulation"
  end

  create_table "ways", force: :cascade do |t|
    t.string   "way_name",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spanish_name", limit: 255
    t.string   "way_value",    limit: 255
  end

  create_table "weathers", force: :cascade do |t|
    t.integer  "field_id",                limit: 4
    t.integer  "station_id",              limit: 4
    t.string   "station_way",             limit: 255
    t.integer  "simulation_initial_year", limit: 4
    t.integer  "simulation_final_year",   limit: 4
    t.float    "longitude",               limit: 24
    t.float    "latitude",                limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "weather_file",            limit: 255
    t.integer  "way_id",                  limit: 4
    t.integer  "weather_initial_year",    limit: 4
    t.integer  "weather_final_year",      limit: 4
  end

end
