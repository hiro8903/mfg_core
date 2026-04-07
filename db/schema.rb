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

ActiveRecord::Schema[8.1].define(version: 2026_04_07_071730) do
  create_table "accounting_usage_codes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_accounting_usage_codes_on_code", unique: true
  end

  create_table "approval_activities", force: :cascade do |t|
    t.string "action"
    t.integer "approver_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "material_request_id", null: false
    t.string "step_name"
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_approval_activities_on_approver_id"
    t.index ["material_request_id"], name: "index_approval_activities_on_material_request_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.text "internal_memo"
    t.boolean "is_primary", default: true, null: false
    t.string "job_title"
    t.integer "org_unit_id", null: false
    t.integer "role", default: 0, null: false
    t.integer "site_id", null: false
    t.date "start_date", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["org_unit_id"], name: "index_assignments_on_org_unit_id"
    t.index ["site_id"], name: "index_assignments_on_site_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "business_partners", force: :cascade do |t|
    t.string "address"
    t.string "business_type"
    t.bigint "capital_amount"
    t.string "corporate_number"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "fax_number"
    t.text "internal_memo"
    t.string "invoice_registration_number"
    t.boolean "is_customer", default: false, null: false
    t.boolean "is_manufacturer", default: false, null: false
    t.boolean "is_supplier", default: false, null: false
    t.string "name", null: false
    t.string "name_kana"
    t.integer "parent_id"
    t.string "partner_code", null: false
    t.string "phone_number"
    t.string "postal_code"
    t.string "search_keywords"
    t.string "short_name", null: false
    t.integer "trade_status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.index ["discarded_at"], name: "index_business_partners_on_discarded_at"
    t.index ["parent_id"], name: "index_business_partners_on_parent_id"
    t.index ["partner_code"], name: "index_business_partners_on_partner_code", unique: true
  end

  create_table "delivery_destinations", force: :cascade do |t|
    t.string "address"
    t.integer "business_partner_id", null: false
    t.string "contact_person_name"
    t.string "contact_person_org"
    t.string "contact_person_title"
    t.datetime "created_at", null: false
    t.string "destination_code", null: false
    t.datetime "discarded_at"
    t.string "email"
    t.string "fax_number"
    t.string "honorific_title"
    t.text "internal_memo"
    t.boolean "is_active", default: true, null: false
    t.boolean "is_default", default: false, null: false
    t.string "name", null: false
    t.string "name_kana"
    t.string "phone_number"
    t.string "postal_code"
    t.string "search_keywords"
    t.string "shipping_instruction"
    t.string "short_name", null: false
    t.datetime "updated_at", null: false
    t.index ["business_partner_id"], name: "index_delivery_destinations_on_business_partner_id"
    t.index ["destination_code"], name: "index_delivery_destinations_on_destination_code", unique: true
    t.index ["discarded_at"], name: "index_delivery_destinations_on_discarded_at"
  end

  create_table "internal_usage_codes", force: :cascade do |t|
    t.integer "accounting_usage_code_id"
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["accounting_usage_code_id"], name: "index_internal_usage_codes_on_accounting_usage_code_id"
    t.index ["code"], name: "index_internal_usage_codes_on_code", unique: true
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

  create_table "item_boms", force: :cascade do |t|
    t.integer "child_item_id", null: false
    t.datetime "created_at", null: false
    t.text "note"
    t.integer "parent_item_id", null: false
    t.decimal "quantity", precision: 15, scale: 5, null: false
    t.datetime "updated_at", null: false
    t.index ["child_item_id"], name: "index_item_boms_on_child_item_id"
    t.index ["parent_item_id", "child_item_id"], name: "index_item_boms_on_parent_item_id_and_child_item_id", unique: true
    t.index ["parent_item_id"], name: "index_item_boms_on_parent_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.text "internal_memo"
    t.boolean "is_lot_managed", default: false, null: false
    t.string "item_code", null: false
    t.integer "item_type", default: 0, null: false
    t.integer "managing_org_id"
    t.string "manufacturer_name"
    t.decimal "min_stock_level", precision: 15, scale: 5, default: "0.0", null: false
    t.string "name", null: false
    t.string "unit", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_items_on_discarded_at"
    t.index ["item_code"], name: "index_items_on_item_code", unique: true
    t.index ["managing_org_id"], name: "index_items_on_managing_org_id"
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.text "internal_memo"
    t.string "location_code", null: false
    t.string "name", null: false
    t.integer "site_id", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_locations_on_discarded_at"
    t.index ["site_id", "location_code"], name: "index_locations_on_site_id_and_location_code", unique: true
    t.index ["site_id"], name: "index_locations_on_site_id"
  end

  create_table "material_request_lines", force: :cascade do |t|
    t.string "base_unit"
    t.decimal "base_unit_price", precision: 15, scale: 4
    t.datetime "created_at", null: false
    t.integer "item_id"
    t.string "item_name_free_text"
    t.text "item_spec_free_text"
    t.integer "material_request_id", null: false
    t.decimal "order_quantity", precision: 15, scale: 5
    t.string "order_unit"
    t.decimal "packing_factor", precision: 15, scale: 5
    t.date "required_date"
    t.integer "status", default: 0, null: false
    t.decimal "tax_rate", precision: 5, scale: 4, default: "0.1"
    t.decimal "total_base_quantity", precision: 15, scale: 5
    t.decimal "unit_price", precision: 15, scale: 4
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_material_request_lines_on_item_id"
    t.index ["material_request_id"], name: "index_material_request_lines_on_material_request_id"
  end

  create_table "material_requests", force: :cascade do |t|
    t.integer "applicant_id", null: false
    t.integer "budget_org_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id", null: false
    t.text "purpose"
    t.text "reason"
    t.text "remarks"
    t.integer "request_org_id"
    t.boolean "ringi_needed", default: false, null: false
    t.integer "status", default: 0, null: false
    t.integer "target_org_id"
    t.integer "transaction_type", default: 1, null: false
    t.datetime "updated_at", null: false
    t.integer "usage_code_id"
    t.index ["applicant_id"], name: "index_material_requests_on_applicant_id"
    t.index ["budget_org_id"], name: "index_material_requests_on_budget_org_id"
    t.index ["created_by_id"], name: "index_material_requests_on_created_by_id"
    t.index ["request_org_id"], name: "index_material_requests_on_request_org_id"
    t.index ["target_org_id"], name: "index_material_requests_on_target_org_id"
    t.index ["usage_code_id"], name: "index_material_requests_on_usage_code_id"
  end

  create_table "org_unit_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "internal_memo"
    t.integer "org_unit_id", null: false
    t.string "permission_key", null: false
    t.integer "permission_level", default: 0, null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["org_unit_id", "role", "permission_key"], name: "idx_org_unit_role_perm_unique", unique: true
    t.index ["org_unit_id"], name: "index_org_unit_permissions_on_org_unit_id"
  end

  create_table "org_units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.text "internal_memo"
    t.string "name", null: false
    t.string "org_code", null: false
    t.integer "org_type", default: 0, null: false
    t.integer "parent_id"
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_org_units_on_discarded_at"
    t.index ["org_code"], name: "index_org_units_on_org_code", unique: true
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

  create_table "sites", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "fax_number"
    t.text "internal_memo"
    t.string "name", null: false
    t.string "phone_number"
    t.string "postal_code"
    t.string "site_code", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_sites_on_discarded_at"
    t.index ["site_code"], name: "index_sites_on_site_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.bigint "business_partner_id"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.integer "employment_type", default: 0, null: false
    t.text "internal_memo"
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.integer "user_category", default: 0, null: false
    t.string "user_code", null: false
    t.index ["business_partner_id"], name: "index_users_on_business_partner_id"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["user_code"], name: "index_users_on_user_code", unique: true
  end

  add_foreign_key "approval_activities", "material_requests"
  add_foreign_key "approval_activities", "users", column: "approver_id"
  add_foreign_key "assignments", "org_units"
  add_foreign_key "assignments", "sites"
  add_foreign_key "assignments", "users"
  add_foreign_key "business_partners", "business_partners", column: "parent_id"
  add_foreign_key "delivery_destinations", "business_partners"
  add_foreign_key "internal_usage_codes", "accounting_usage_codes"
  add_foreign_key "inventories", "items"
  add_foreign_key "inventories", "locations"
  add_foreign_key "inventories", "org_units"
  add_foreign_key "item_boms", "items", column: "child_item_id"
  add_foreign_key "item_boms", "items", column: "parent_item_id"
  add_foreign_key "items", "org_units", column: "managing_org_id"
  add_foreign_key "locations", "sites"
  add_foreign_key "material_request_lines", "items"
  add_foreign_key "material_request_lines", "material_requests"
  add_foreign_key "material_requests", "internal_usage_codes", column: "usage_code_id"
  add_foreign_key "material_requests", "org_units", column: "budget_org_id"
  add_foreign_key "material_requests", "org_units", column: "request_org_id"
  add_foreign_key "material_requests", "org_units", column: "target_org_id"
  add_foreign_key "material_requests", "users", column: "applicant_id"
  add_foreign_key "material_requests", "users", column: "created_by_id"
  add_foreign_key "org_unit_permissions", "org_units"
  add_foreign_key "org_units", "org_units", column: "parent_id"
  add_foreign_key "sessions", "users"
end
