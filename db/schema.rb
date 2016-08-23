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

ActiveRecord::Schema.define(version: 20160823191631) do

  create_table "pluses", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "pluses", ["recipient_id"], name: "index_pluses_on_recipient_id"
  add_index "pluses", ["sender_id"], name: "index_pluses_on_sender_id"

  create_table "team_members", force: :cascade do |t|
    t.integer  "team_id",                     null: false
    t.string   "slack_user_id"
    t.string   "slack_user_name",             null: false
    t.integer  "points",          default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "slack_team_id",     null: false
    t.string   "slack_team_domain", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slack_token"
  end

end
