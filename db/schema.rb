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

ActiveRecord::Schema.define(version: 20141217194942) do

  create_table "access_groups", force: true do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "access_groups_projects", id: false, force: true do |t|
    t.integer "access_group_id", null: false
    t.integer "project_id",      null: false
  end

  create_table "access_groups_users", id: false, force: true do |t|
    t.integer "access_group_id", null: false
    t.integer "user_id",         null: false
  end

  create_table "assets", force: true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "data_tracks", force: true do |t|
    t.string   "name"
    t.text     "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "technician"
    t.boolean  "public",                  default: false
    t.integer  "user_id"
    t.date     "recorded_on"
    t.integer  "take_id"
  end

  add_index "data_tracks", ["user_id"], name: "index_data_tracks_on_user_id"

  create_table "data_tracks_movers", id: false, force: true do |t|
    t.integer "data_track_id"
    t.integer "mover_id"
  end

  create_table "data_tracks_sensor_types", id: false, force: true do |t|
    t.integer "sensor_type_id", null: false
    t.integer "data_track_id",  null: false
  end

  create_table "movement_annotations", force: true do |t|
    t.string   "name"
    t.text     "description",   limit: 255
    t.string   "format"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                    default: false
    t.integer  "user_id"
    t.integer  "attached_id"
    t.string   "attached_type"
  end

  add_index "movement_annotations", ["attached_id", "attached_type"], name: "index_movement_annotations_on_attached_id_and_attached_type"
  add_index "movement_annotations", ["user_id"], name: "index_movement_annotations_on_user_id"

  create_table "movement_groups", force: true do |t|
    t.string   "name"
    t.text     "description", limit: 255
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                  default: false
    t.integer  "user_id"
  end

  add_index "movement_groups", ["user_id"], name: "index_movement_groups_on_user_id"

  create_table "movement_groups_movers", id: false, force: true do |t|
    t.integer "movement_group_id"
    t.integer "mover_id"
  end

  create_table "movement_groups_sensor_types", id: false, force: true do |t|
    t.integer "sensor_type_id",    null: false
    t.integer "movement_group_id", null: false
  end

  create_table "movers", force: true do |t|
    t.string   "name"
    t.date     "dob"
    t.string   "gender"
    t.string   "expertise"
    t.boolean  "cma_like_training"
    t.string   "other_training"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "movers_projects", id: false, force: true do |t|
    t.integer "mover_id",   null: false
    t.integer "project_id", null: false
  end

  create_table "movers_takes", id: false, force: true do |t|
    t.integer "mover_id", null: false
    t.integer "take_id",  null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", limit: 255
    t.boolean  "public",                  default: false
    t.integer  "user_id"
    t.text     "license"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

  create_table "projects_sensor_types", id: false, force: true do |t|
    t.integer "sensor_type_id", null: false
    t.integer "project_id",     null: false
  end

  create_table "sensor_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "takes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "movement_group_id"
    t.boolean  "public"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "takes", ["movement_group_id"], name: "index_takes_on_movement_group_id"
  add_index "takes", ["user_id"], name: "index_takes_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "alias"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end
