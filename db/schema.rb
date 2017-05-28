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

ActiveRecord::Schema.define(version: 20170528150528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer  "sub_main_category_id"
    t.integer  "sequence_id",                         null: false
    t.string   "name",                                null: false
    t.text     "description"
    t.boolean  "display_home_status",  default: true
    t.string   "meta_title"
    t.string   "meta_keyword"
    t.text     "meta_description"
    t.boolean  "active",               default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "categories", ["sub_main_category_id"], name: "index_categories_on_sub_main_category_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.integer  "state_id"
    t.string   "name",                                                        null: false
    t.string   "code",                                                        null: false
    t.decimal  "min_shipping_charge", precision: 12, scale: 2, default: 0.0
    t.boolean  "active",                                       default: true
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "code",                      null: false
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "devise_multiple_token_auth_devices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "auth_token", null: false
    t.string   "platform"
    t.string   "push_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "devise_multiple_token_auth_devices", ["auth_token"], name: "index_devise_multiple_token_auth_devices_on_auth_token", unique: true, using: :btree
  add_index "devise_multiple_token_auth_devices", ["user_id"], name: "index_devise_multiple_token_auth_devices_on_user_id", using: :btree

  create_table "main_categories", force: :cascade do |t|
    t.integer  "city_id"
    t.integer  "sequence_id",                null: false
    t.string   "name",                       null: false
    t.string   "icon",                       null: false
    t.boolean  "active",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "main_categories", ["city_id"], name: "index_main_categories_on_city_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.integer  "country_id"
    t.string   "name",                      null: false
    t.string   "code",                      null: false
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id", using: :btree

  create_table "sub_main_categories", force: :cascade do |t|
    t.integer  "main_category_id"
    t.integer  "sequence_id",                     null: false
    t.string   "name",                            null: false
    t.boolean  "active",           default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "sub_main_categories", ["main_category_id"], name: "index_sub_main_categories_on_main_category_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: "",    null: false
    t.string   "last_name",              default: "",    null: false
    t.string   "mobile",                 default: "",    null: false
    t.string   "username",               default: "",    null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "role",                   default: "",    null: false
    t.boolean  "active",                 default: true
    t.boolean  "archive",                default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "categories", "sub_main_categories"
  add_foreign_key "cities", "states"
  add_foreign_key "main_categories", "cities"
  add_foreign_key "states", "countries"
  add_foreign_key "sub_main_categories", "main_categories"
end
