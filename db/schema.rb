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

ActiveRecord::Schema.define(:version => 20101019205840) do

  create_table "chapters", :force => true do |t|
    t.string   "region"
    t.text     "description"
    t.text     "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapters_countries", :id => false, :force => true do |t|
    t.integer "chapter_id"
    t.integer "country_id"
  end

  create_table "countries", :force => true do |t|
    t.string   "geoname_id"
    t.string   "country_code"
    t.string   "fips_code"
    t.string   "currency_code"
    t.string   "iso_numeric"
    t.string   "iso_alpha3"
    t.string   "continent"
    t.string   "name"
    t.string   "capital"
    t.string   "languages"
    t.string   "area_in_sq_km"
    t.string   "population"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.string   "email"
    t.string   "password_hash"
    t.string   "salt"
    t.string   "status"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
