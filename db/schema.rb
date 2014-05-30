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

ActiveRecord::Schema.define(version: 20140523225526) do

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
    t.text     "description",       limit: 255
    t.integer  "movement_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "technician"
    t.integer  "sensor_type_id"
    t.boolean  "public",                        default: false
    t.integer  "user_id"
  end

  add_index "data_tracks", ["sensor_type_id"], name: "index_data_tracks_on_sensor_type_id"
  add_index "data_tracks", ["user_id"], name: "index_data_tracks_on_user_id"

  create_table "data_tracks_movers", id: false, force: true do |t|
    t.integer "data_track_id"
    t.integer "mover_id"
  end

  create_table "movement_annotations", force: true do |t|
    t.string   "name"
    t.text     "description",   limit: 255
    t.string   "format"
    t.integer  "data_track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                    default: false
    t.integer  "user_id"
  end

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

  create_table "movers", force: true do |t|
    t.string   "name"
    t.date     "dob"
    t.string   "gender"
    t.string   "expertise"
    t.boolean  "cma_like_training"
    t.string   "other_training"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", limit: 255
    t.boolean  "public",                  default: false
    t.integer  "user_id"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

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

  create_table "users", force: true do |t|
    t.string "email"
    t.string "hashed_password"
    t.string "alias"
  end

end
