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

ActiveRecord::Schema.define(:version => 20101120181839) do

  create_table "chapters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geographic_location_id"
    t.string   "name"
    t.string   "category"
    t.string   "status"
  end

  create_table "coordinators", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "chapter_id"
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

  create_table "geographic_locations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "name"
    t.integer  "geoname_id"
  end

  create_table "geographic_territories", :force => true do |t|
    t.string   "name"
    t.integer  "geoname_id"
    t.string   "fcode"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "uri"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_options", :force => true do |t|
    t.string   "key"
    t.string   "type"
    t.string   "value"
    t.boolean  "mutable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geographic_location_id"
    t.integer  "chapter_id"
    t.string   "name"
    t.string   "username"
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                         :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                                 :default => false
  end

end
