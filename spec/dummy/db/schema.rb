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

ActiveRecord::Schema.define(:version => 20120220093114) do

  create_table "zip_codes", :force => true do |t|
    t.string   "organization_code",   :limit => 6, :null => false
    t.string   "zip5",                :limit => 5
    t.string   "zip",                 :limit => 7, :null => false
    t.string   "prefecture_phonetic",              :null => false
    t.string   "city_phonetic",                    :null => false
    t.string   "street_phonetic"
    t.string   "prefecture",                       :null => false
    t.string   "city",                             :null => false
    t.string   "street"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "zip_codes", ["organization_code"], :name => "index_zip_codes_on_organization_code"
  add_index "zip_codes", ["zip"], :name => "index_zip_codes_on_zip"

end
