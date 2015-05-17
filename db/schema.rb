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

ActiveRecord::Schema.define(version: 20150517202044) do

  create_table "apps", force: true do |t|
    t.string   "mentee_id"
    t.string   "mentor_id"
    t.string   "reader_1"
    t.string   "reader_2"
    t.float    "score_1"
    t.float    "score_2"
    t.datetime "submitted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cohorts", force: true do |t|
    t.string   "title"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "comment"
    t.string   "core_member_id"
    t.string   "app_id"
    t.datetime "date_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_members", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "year"
    t.string   "email"
    t.string   "phone"
    t.string   "team"
    t.string   "position"
    t.text     "bio"
    t.string   "cohort_id"
    t.string   "mentor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counselors", force: true do |t|
    t.string   "name"
    t.string   "highschool_id"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "timestamp"
    t.string   "person_id"
    t.string   "event_type"
    t.string   "title"
    t.string   "description"
    t.string   "flag"
    t.string   "resolved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "highschools", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "num_students"
    t.string   "num_counselors"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mass_text_messages", force: true do |t|
    t.datetime "sent_at"
    t.string   "content"
    t.string   "name"
    t.integer  "text_cohort_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentee_outreach_responses", force: true do |t|
    t.string   "mentee_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "response_type"
    t.string   "highschool_id"
    t.string   "t_msg_id"
    t.string   "t_msg_from_city"
    t.string   "t_msg_from_state"
    t.string   "t_msg_from_zip"
    t.string   "t_msg_body"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentees", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "year"
    t.string   "highschool_id"
    t.string   "email"
    t.string   "phone_1"
    t.string   "phone_2"
    t.string   "phone_1_can_text"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.text     "ethnicity"
    t.string   "free_lunch"
    t.string   "income_range"
    t.string   "people_in_home"
    t.string   "is_first_gen"
    t.string   "GPA_u"
    t.string   "GPA_w"
    t.string   "SAT"
    t.string   "ACT"
    t.string   "mentor_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "year"
    t.string   "other_ids"
    t.string   "gender"
    t.string   "grad_year"
    t.string   "major"
    t.string   "hometown"
    t.string   "state"
    t.string   "PO_box"
    t.string   "email"
    t.string   "phone"
    t.string   "highschool_id"
    t.text     "ethnicity"
    t.string   "prior_mentor"
    t.text     "demographics"
    t.string   "cohort_id"
    t.string   "core_member_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.text     "Q"
    t.text     "A"
    t.string   "survey_id"
    t.string   "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "surveys", force: true do |t|
    t.string   "mentee_id"
    t.string   "mentor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_cohort_entries", force: true do |t|
    t.string   "phone"
    t.string   "fields_json"
    t.integer  "text_cohort_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_cohorts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "password"
    t.string   "permissions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
