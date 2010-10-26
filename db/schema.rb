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

ActiveRecord::Schema.define(:version => 20101026192858) do

  create_table "chapters", :force => true do |t|
    t.string   "region"
    t.text     "description"
    t.text     "language"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count", :default => 0
  end

  add_index "chapters", ["region"], :name => "index_chapters_on_region"

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

  create_table "external_urls", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.string   "type"
    t.integer  "sort_order", :default => 0
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.string   "status"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["confirmation_token"], :name => "index_members_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_members_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true

end
