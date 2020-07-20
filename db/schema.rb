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

ActiveRecord::Schema.define(version: 2020_07_19_013243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channel_sources", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.string "ident", null: false
    t.string "url", null: false
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_channel_sources_on_channel_id"
  end

  create_table "channels", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "image"
    t.text "tags", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "features", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "expire_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_features_on_channel_id"
  end

  create_table "video_sources", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.string "ident", null: false
    t.string "url", null: false
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["video_id"], name: "index_video_sources_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "published_at"
    t.bigint "channel_id", null: false
    t.text "tags", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_videos_on_channel_id"
  end

  add_foreign_key "channel_sources", "channels"
  add_foreign_key "features", "channels"
  add_foreign_key "video_sources", "videos"
  add_foreign_key "videos", "channels"
end
