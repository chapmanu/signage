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

ActiveRecord::Schema.define(version: 20150811225543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.string   "name"
    t.string   "template"
    t.string   "location"
    t.string   "notification"
    t.string   "notification_detail"
    t.string   "emergency"
    t.string   "emergency_detail"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "devices_slides", id: false, force: :cascade do |t|
    t.integer "device_id", null: false
    t.integer "slide_id",  null: false
  end

  add_index "devices_slides", ["device_id", "slide_id"], name: "index_devices_slides_on_device_id_and_slide_id", using: :btree
  add_index "devices_slides", ["slide_id", "device_id"], name: "index_devices_slides_on_slide_id_and_device_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.string   "email"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people_slides", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "slide_id",  null: false
  end

  add_index "people_slides", ["person_id", "slide_id"], name: "index_people_slides_on_person_id_and_slide_id", using: :btree
  add_index "people_slides", ["slide_id", "person_id"], name: "index_people_slides_on_slide_id_and_person_id", using: :btree

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
  end

  add_index "scheduled_items", ["slide_id"], name: "index_scheduled_items_on_slide_id", using: :btree

  create_table "slides", force: :cascade do |t|
    t.string   "name"
    t.string   "template"
    t.string   "menu_name"
    t.string   "organizer"
    t.string   "organizer_id"
    t.integer  "duration",          default: 20,   null: false
    t.string   "heading"
    t.string   "subheading"
    t.string   "location"
    t.text     "content"
    t.string   "background"
    t.string   "background_type"
    t.string   "background_sizing"
    t.string   "foreground"
    t.string   "foreground_type"
    t.string   "foreground_sizing"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "theme"
    t.string   "layout"
    t.string   "directory_feed"
    t.datetime "play_on"
    t.datetime "stop_on"
    t.boolean  "show",              default: true, null: false
    t.string   "datetime"
  end

  add_foreign_key "scheduled_items", "slides"
end
