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

ActiveRecord::Schema.define(:version => 20140819043910) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "gameholders", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "court_name"
    t.string   "city"
    t.string   "county"
    t.string   "zipcode"
    t.text     "address"
    t.float    "lng"
    t.float    "lat"
    t.string   "phone"
    t.string   "sponsor"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "approved"
  end

  add_index "gameholders", ["city"], :name => "index_gameholders_on_city"
  add_index "gameholders", ["county"], :name => "index_gameholders_on_county"
  add_index "gameholders", ["user_id"], :name => "index_gameholders_on_user_id"
  add_index "gameholders", ["zipcode"], :name => "index_gameholders_on_zipcode"

  create_table "games", :force => true do |t|
    t.string   "gamename"
    t.date     "gamedate"
    t.text     "players_result"
    t.string   "uploader"
    t.text     "detailgameinfo"
    t.string   "originalfileurl"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "playerprofiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "initscore",           :default => 0
    t.integer  "curscore"
    t.integer  "totalwongames",       :default => 0
    t.integer  "totallosegames",      :default => 0
    t.date     "lastgamedate"
    t.string   "lastgamename"
    t.date     "lastscoreupdatedate"
    t.text     "gamehistory"
    t.string   "profileurl"
    t.string   "imageurl"
    t.string   "bio"
    t.string   "paddleholdtype"
    t.string   "paddlemodel"
    t.string   "forwardrubber"
    t.string   "backrubber"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "ttcourts", :force => true do |t|
    t.string   "placename"
    t.float    "lng"
    t.float    "lat"
    t.string   "city"
    t.string   "county"
    t.string   "zipcode"
    t.text     "address"
    t.text     "opentime"
    t.text     "facilities"
    t.text     "playfee"
    t.text     "contactinfo"
    t.text     "supplyinfo"
    t.text     "infosource"
    t.text     "infoURL"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "ttcourts", ["city"], :name => "index_ttcourts_on_city"
  add_index "ttcourts", ["county"], :name => "index_ttcourts_on_county"
  add_index "ttcourts", ["lat"], :name => "index_ttcourts_on_lat"
  add_index "ttcourts", ["lng"], :name => "index_ttcourts_on_lng"
  add_index "ttcourts", ["placename"], :name => "index_ttcourts_on_placename"
  add_index "ttcourts", ["zipcode"], :name => "index_ttcourts_on_zipcode"

  create_table "uploadgames", :force => true do |t|
    t.string   "gamename"
    t.date     "gamedate"
    t.text     "players_result"
    t.string   "uploader"
    t.text     "detailgameinfo"
    t.string   "originalfileurl"
    t.boolean  "publishedforchecking"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "suggestscore"
    t.string   "recorder"
    t.boolean  "scorecaculated"
    t.text     "adjustplayersinfo"
  end

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "fbaccount",              :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "playerphoto"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
