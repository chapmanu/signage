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

ActiveRecord::Schema.define(version: 20161025224137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "faculties", force: :cascade do |t|
    t.integer  "datatel_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "full_name"
    t.string   "email"
    t.string   "phone"
    t.string   "building_name"
    t.string   "office_name"
    t.string   "building_name_2"
    t.string   "office_name_2"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "thumbnail"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "scheduled_items", force: :cascade do |t|
    t.string   "date"
    t.string   "time"
    t.string   "image"
    t.string   "name"
    t.text     "content"
    t.string   "admission"
    t.string   "audience"
    t.string   "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "slide_id"
    t.datetime "play_on"
    t.datetime "stop_on"
  end

  add_index "scheduled_items", ["slide_id"], name: "index_scheduled_items_on_slide_id", using: :btree

  create_table "sign_slides", force: :cascade do |t|
    t.integer  "order"
    t.integer  "sign_id"
    t.integer  "slide_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "approved",   default: false
  end

  add_index "sign_slides", ["sign_id"], name: "index_sign_slides_on_sign_id", using: :btree
  add_index "sign_slides", ["slide_id"], name: "index_sign_slides_on_slide_id", using: :btree

  create_table "sign_users", force: :cascade do |t|
    t.integer  "sign_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sign_users", ["sign_id"], name: "index_sign_users_on_sign_id", using: :btree
  add_index "sign_users", ["user_id"], name: "index_sign_users_on_user_id", using: :btree

  create_table "signs", force: :cascade do |t|
    t.string   "name"
    t.string   "template"
    t.string   "location"
    t.string   "notification"
    t.string   "notification_detail"
    t.string   "emergency"
    t.string   "emergency_detail"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "slug"
    t.datetime "last_ping"
    t.string   "panther_alert"
    t.string   "panther_alert_detail"
    t.string   "transition"
  end

  add_index "signs", ["slug"], name: "index_signs_on_slug", unique: true, using: :btree

  create_table "slide_users", force: :cascade do |t|
    t.integer  "slide_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "slide_users", ["slide_id"], name: "index_slide_users_on_slide_id", using: :btree
  add_index "slide_users", ["user_id"], name: "index_slide_users_on_user_id", using: :btree

  create_table "slides", force: :cascade do |t|
    t.string   "name"
    t.string   "template"
    t.string   "menu_name"
    t.string   "organizer"
    t.string   "organizer_id"
    t.integer  "duration",                            null: false
    t.string   "heading"
    t.string   "subheading"
    t.string   "location"
    t.text     "content"
    t.string   "background"
    t.string   "background_type",   default: "none"
    t.string   "background_sizing"
    t.string   "foreground"
    t.string   "foreground_type",   default: "none"
    t.string   "foreground_sizing", default: "cover"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "theme",             default: "light"
    t.string   "layout",            default: "left"
    t.string   "building_name"
    t.datetime "play_on"
    t.datetime "stop_on"
    t.boolean  "show",              default: true,    null: false
    t.string   "datetime"
    t.string   "screenshot"
    t.integer  "signs_count",       default: 0,       null: false
    t.string   "feed_url"
    t.integer  "sponsor_id"
  end

  add_index "slides", ["sponsor_id"], name: "index_slides_on_sponsor_id", using: :btree

  create_table "sponsors", force: :cascade do |t|
    t.string "name"
    t.string "icon"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "scheduled_items", "slides"
  add_foreign_key "sign_slides", "signs"
  add_foreign_key "sign_slides", "slides"
  add_foreign_key "sign_users", "signs"
  add_foreign_key "sign_users", "users"
  add_foreign_key "slide_users", "slides"
  add_foreign_key "slide_users", "users"
end
