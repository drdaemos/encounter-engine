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

ActiveRecord::Schema.define(version: 20180705195417) do

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "level_id"
    t.string  "value"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "game_entries", force: :cascade do |t|
    t.integer "game_id"
    t.integer "team_id"
    t.string  "status"
  end

  create_table "game_passings", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "team_id"
    t.integer  "current_level_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "finished_at"
    t.datetime "current_level_entered_at"
    t.text     "answered_questions"
    t.string   "status"
    t.text     "opened_spoilers"
  end

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "author_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "starts_at"
    t.boolean  "is_draft",               default: false, null: false
    t.integer  "max_team_number"
    t.integer  "requested_teams_number", default: 0
    t.datetime "registration_deadline"
    t.datetime "author_finished_at"
    t.boolean  "is_testing",             default: false, null: false
    t.text     "preserved_data"
    t.text     "notes"
    t.text     "accessories"
    t.datetime "finished_at"
    t.string   "poster"
    t.boolean  "is_published",           default: false, null: false
  end

  create_table "hints", force: :cascade do |t|
    t.integer  "level_id"
    t.string   "text"
    t.integer  "delay"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "penalty_time"
    t.string   "access_code"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "to_team_id"
    t.integer  "for_user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "level_results", force: :cascade do |t|
    t.text     "answered_questions"
    t.integer  "game_passing_id"
    t.integer  "level_id"
    t.integer  "adjustment"
    t.datetime "entered_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "time_limit"
  end

  create_table "levels", force: :cascade do |t|
    t.text     "text"
    t.integer  "game_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "position"
    t.string   "name"
    t.integer  "time_limit"
    t.boolean  "is_used_in_stats",         default: true, null: false
    t.boolean  "is_all_sectors_required",  default: true, null: false
    t.integer  "count_of_sectors_to_pass"
    t.integer  "penalty_time_fail"
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "game_passing_id"
    t.integer  "level_id"
    t.string   "answer"
    t.boolean  "is_correct"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "linkable_type"
    t.integer  "linkable_id"
    t.index ["linkable_type", "linkable_id"], name: "index_logs_on_linkable_type_and_linkable_id"
  end

  create_table "passing_adjustments", force: :cascade do |t|
    t.integer  "game_passing_id"
    t.integer  "adjustment"
    t.string   "reason"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "questions"
    t.integer  "level_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "is_counted_in_level", default: true, null: false
    t.integer  "penalty_time"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.text   "value"
    t.string "field_type", default: "text"
    t.string "label"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "captain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.string   "picture"
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "nickname"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "team_id"
    t.string   "jabber_id"
    t.string   "icq_number"
    t.date     "date_of_birth"
    t.string   "phone_number"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar"
    t.integer  "access_level"
    t.string   "slug"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

end
