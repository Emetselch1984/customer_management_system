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

ActiveRecord::Schema.define(version: 2021_07_02_000938) do
  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type", null: false
    t.string "postal_code", null: false
    t.string "prefecture", null: false
    t.string "city", null: false
    t.string "address1", null: false
    t.string "address2", null: false
    t.string "company_name", default: "", null: false
    t.string "division_name", default: "", null: false
    t.index ["city"], name: "index_addresses_on_city"
    t.index ["prefecture", "city"], name: "index_addresses_on_prefecture_and_city"
    t.index ["type", "city"], name: "index_addresses_on_type_and_city"
    t.index ["type", "prefecture", "city"], name: "index_addresses_on_type_and_prefecture_and_city"
    t.index ["type", "user_id"], name: "index_addresses_on_type_and_user_id", unique: true
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end


  create_table "entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "user_id", null: false
    t.boolean "approved", default: false, null: false
    t.boolean "canceled", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["program_id", "user_id"], name: "index_entries_on_program_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_entries_on_user_id"
  end


  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "root_id"
    t.bigint "parent_id"
    t.string "type", null: false
    t.string "status", default: "new", null: false
    t.string "subject", null: false
    t.text "body"
    t.text "remarks"
    t.boolean "discarded", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "staff_id"
    t.index ["parent_id"], name: "fk_rails_aafcb31dbf"
    t.index ["root_id", "deleted", "created_at"], name: "index_messages_on_root_id_and_deleted_and_created_at"
    t.index ["type", "user_id"], name: "index_messages_on_type_and_user_id"
    t.index ["user_id", "deleted", "created_at"], name: "index_messages_on_user_id_and_deleted_and_created_at"
    t.index ["user_id", "deleted", "status", "created_at"], name: "index_messages_on_c_d_s_c"
    t.index ["user_id", "discarded", "created_at"], name: "index_messages_on_user_id_and_discarded_and_created_at"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "phones", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "address_id"
    t.string "number", null: false
    t.string "number_for_index", null: false
    t.boolean "primary", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_phones_on_address_id"
    t.index ["number_for_index"], name: "index_phones_on_number_for_index"
    t.index ["user_id"], name: "index_phones_on_user_id"
  end


  create_table "programs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "registrant_id", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "application_start_time", null: false
    t.datetime "application_end_time", null: false
    t.integer "min_number_of_participants"
    t.integer "max_number_of_participants"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_start_time"], name: "index_programs_on_application_start_time"
    t.index ["registrant_id"], name: "index_programs_on_registrant_id"
  end
  create_table "staff_events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_staff_events_on_created_at"
    t.index ["user_id", "created_at"], name: "index_staff_events_on_user_id_and_created_at"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "type", default: "Staff"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "family_name"
    t.string "given_name"
    t.string "family_name_kana"
    t.string "given_name_kana"
    t.date "start_date"
    t.date "end_date"
    t.boolean "suspended", default: false
    t.string "gender"
    t.date "birthday"
    t.integer "birth_year"
    t.integer "birth_month"
    t.integer "birth_mday"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["birth_mday", "family_name_kana", "given_name_kana"], name: "index_customers_on_birth_mday_and_furigana"
    t.index ["birth_mday", "given_name_kana"], name: "index_users_on_birth_mday_and_given_name_kana"
    t.index ["birth_month", "birth_mday"], name: "index_users_on_birth_month_and_birth_mday"
    t.index ["birth_month", "family_name_kana", "given_name_kana"], name: "index_customers_on_birth_month_and_furigana"
    t.index ["birth_month", "given_name_kana"], name: "index_users_on_birth_month_and_given_name_kana"
    t.index ["birth_year", "birth_month", "birth_mday"], name: "index_users_on_birth_year_and_birth_month_and_birth_mday"
    t.index ["birth_year", "family_name_kana", "given_name_kana"], name: "index_customers_on_birth_year_and_furigana"
    t.index ["birth_year", "given_name_kana"], name: "index_users_on_birth_year_and_given_name_kana"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["given_name_kana"], name: "index_users_on_given_name_kana"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "entries", "programs"
  add_foreign_key "entries", "users"
  add_foreign_key "messages", "messages", column: "parent_id"
  add_foreign_key "messages", "messages", column: "root_id"
  add_foreign_key "messages", "users"
  add_foreign_key "phones", "addresses"
  add_foreign_key "phones", "users"
  add_foreign_key "programs", "users", column: "registrant_id"
  add_foreign_key "staff_events", "users"
end

