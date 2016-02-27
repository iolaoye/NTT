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

ActiveRecord::Schema.define(:version => 20160226222712) do

  create_table "counties", :force => true do |t|
    t.string   "county_name"
    t.string   "county_code"
    t.integer  "status"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "state_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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

  create_table "locations", :force => true do |t|
    t.integer  "state_id"
    t.integer  "county_id"
    t.string   "status"
    t.integer  "project_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "coordinates"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "version"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
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

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "name"
    t.string   "company"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
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
  end

end
