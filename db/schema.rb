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

ActiveRecord::Schema.define(version: 2020_04_30_131642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "study_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_record_id"], name: "index_likes_on_study_record_id"
    t.index ["user_id", "study_record_id"], name: "index_likes_on_user_id_and_study_record_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "study_record_comments", force: :cascade do |t|
    t.bigint "study_record_id"
    t.integer "user_id"
    t.text "comment_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_record_id"], name: "index_study_record_comments_on_study_record_id"
  end

  create_table "study_records", force: :cascade do |t|
    t.integer "user_id"
    t.text "comment"
    t.string "teaching_material"
    t.float "study_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "likes", "study_records"
  add_foreign_key "likes", "users"
  add_foreign_key "study_record_comments", "study_records"
end
