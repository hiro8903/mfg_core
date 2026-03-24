# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_24_113517) do
  create_table "assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.integer "facility_id", null: false
    t.boolean "is_primary", default: true, null: false
    t.string "job_title"
    t.integer "org_unit_id", null: false
    t.integer "role", default: 0, null: false
    t.date "start_date", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["facility_id"], name: "index_assignments_on_facility_id"
    t.index ["org_unit_id"], name: "index_assignments_on_org_unit_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.text "address"
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_facilities_on_code", unique: true
    t.index ["discarded_at"], name: "index_facilities_on_discarded_at"
  end

  create_table "inventories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "item_id"
    t.integer "location_id"
    t.integer "org_unit_id", null: false
    t.decimal "quantity", precision: 15, scale: 5, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_inventories_on_location_id"
    t.index ["org_unit_id"], name: "index_inventories_on_org_unit_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.integer "facility_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_locations_on_discarded_at"
    t.index ["facility_id", "code"], name: "index_locations_on_facility_id_and_code", unique: true
    t.index ["facility_id"], name: "index_locations_on_facility_id"
  end

  create_table "org_units", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "name", null: false
    t.integer "org_type", default: 0, null: false
    t.integer "parent_id"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_org_units_on_code", unique: true
    t.index ["discarded_at"], name: "index_org_units_on_discarded_at"
    t.index ["parent_id"], name: "index_org_units_on_parent_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "user_code", null: false
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["user_code"], name: "index_users_on_user_code", unique: true
  end

  add_foreign_key "assignments", "facilities"
  add_foreign_key "assignments", "org_units"
  add_foreign_key "assignments", "users"
  add_foreign_key "inventories", "locations"
  add_foreign_key "inventories", "org_units"
  add_foreign_key "locations", "facilities"
  add_foreign_key "org_units", "org_units", column: "parent_id"
  add_foreign_key "sessions", "users"
end
