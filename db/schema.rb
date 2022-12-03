# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_12_03_213447) do

  create_table "aliases", force: :cascade do |t|
    t.string "username"
    t.string "user_alias"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "slack_user_id"
    t.string "slack_user_name", null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.string "slack_team_id", null: false
    t.string "slack_team_domain", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slack_token"
  end

  create_table "upvotes", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_upvotes_on_recipient_id"
    t.index ["sender_id"], name: "index_upvotes_on_sender_id"
  end

  add_foreign_key "upvotes", "team_members", column: "recipient_id"
  add_foreign_key "upvotes", "team_members", column: "sender_id"
end
