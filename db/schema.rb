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

ActiveRecord::Schema.define(version: 20131128093220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "adventures", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "armors", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "defense"
    t.integer  "soak"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "encumbrance"
    t.integer  "hard_points"
    t.integer  "rarity"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "career_skills", force: true do |t|
    t.integer  "career_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "careers", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "character_armors", force: true do |t|
    t.integer  "character_id"
    t.integer  "armor_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "character_bonus_talents", force: true do |t|
    t.integer  "character_id"
    t.integer  "talent_id"
    t.string   "bonus_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_gears", force: true do |t|
    t.integer  "character_id"
    t.integer  "gear_id"
    t.integer  "qty"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "character_obligations", force: true do |t|
    t.integer  "character_id"
    t.integer  "obligation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "character_skills", force: true do |t|
    t.integer  "character_id"
    t.integer  "skill_id"
    t.integer  "ranks"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "character_talents", force: true do |t|
    t.integer  "character_id"
    t.integer  "talent_tree_id"
    t.integer  "talent_1_1"
    t.integer  "talent_1_2"
    t.integer  "talent_1_3"
    t.integer  "talent_1_4"
    t.integer  "talent_2_1"
    t.integer  "talent_2_2"
    t.integer  "talent_2_3"
    t.integer  "talent_2_4"
    t.integer  "talent_3_1"
    t.integer  "talent_3_2"
    t.integer  "talent_3_3"
    t.integer  "talent_3_4"
    t.integer  "talent_4_1"
    t.integer  "talent_4_2"
    t.integer  "talent_4_3"
    t.integer  "talent_4_4"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "talent_5_1"
    t.integer  "talent_5_2"
    t.integer  "talent_5_3"
    t.integer  "talent_5_4"
    t.string   "talent_1_1_options"
    t.string   "talent_1_2_options"
    t.string   "talent_1_3_options"
    t.string   "talent_1_4_options"
    t.string   "talent_2_1_options"
    t.string   "talent_2_2_options"
    t.string   "talent_2_3_options"
    t.string   "talent_2_4_options"
    t.string   "talent_3_1_options"
    t.string   "talent_3_2_options"
    t.string   "talent_3_3_options"
    t.string   "talent_3_4_options"
    t.string   "talent_4_1_options"
    t.string   "talent_4_2_options"
    t.string   "talent_4_3_options"
    t.string   "talent_4_4_options"
    t.string   "talent_5_1_options"
    t.string   "talent_5_2_options"
    t.string   "talent_5_3_options"
    t.string   "talent_5_4_options"
  end

  create_table "character_weapons", force: true do |t|
    t.integer  "character_id"
    t.integer  "weapon_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "description"
  end

  create_table "characters", force: true do |t|
    t.string   "name"
    t.string   "race_id"
    t.string   "gender"
    t.string   "career_id"
    t.integer  "brawn"
    t.integer  "agility"
    t.integer  "intellect"
    t.integer  "cunning"
    t.integer  "willpower"
    t.integer  "presence"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.text     "bio"
    t.integer  "credits"
    t.integer  "experience"
    t.integer  "age"
    t.string   "height"
    t.string   "build"
    t.string   "hair"
    t.string   "eyes"
    t.text     "notable_features"
    t.text     "other"
    t.integer  "specialization_1"
    t.integer  "specialization_2"
    t.integer  "specialization_3"
    t.string   "aasm_state"
  end

  create_table "gears", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "encumbrance"
    t.integer  "rarity"
  end

  create_table "obligations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "range"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "race_skills", force: true do |t|
    t.integer  "race_id"
    t.integer  "skill_id"
    t.integer  "ranks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_talents", force: true do |t|
    t.integer  "race_id"
    t.integer  "talent_id"
    t.integer  "ranks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "wound_threshold"
    t.integer  "strain_threshold"
    t.integer  "starting_experience"
    t.text     "special_ability"
    t.integer  "brawn"
    t.integer  "cunning"
    t.integer  "presence"
    t.integer  "agility"
    t.integer  "intellect"
    t.integer  "willpower"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "skills", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "characteristic"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "specializations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "career_id"
  end

  create_table "talent_tree_career_skills", force: true do |t|
    t.integer  "talent_tree_id"
    t.integer  "skill_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "talent_trees", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "talent_1_1"
    t.integer  "talent_1_2"
    t.integer  "talent_1_3"
    t.integer  "talent_1_4"
    t.integer  "talent_2_1"
    t.integer  "talent_2_2"
    t.integer  "talent_3_3"
    t.integer  "talent_4_4"
    t.integer  "talent_3_1"
    t.integer  "talent_3_2"
    t.integer  "talent_3_4"
    t.integer  "talent_4_1"
    t.integer  "talent_4_2"
    t.integer  "talent_4_3"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "talent_2_3"
    t.integer  "talent_2_4"
    t.integer  "career_id"
    t.integer  "talent_2_1_require_1_1"
    t.integer  "talent_2_1_require_2_2"
    t.integer  "talent_2_2_require_1_2"
    t.integer  "talent_2_2_require_2_3"
    t.integer  "talent_2_3_require_1_3"
    t.integer  "talent_2_3_require_2_4"
    t.integer  "talent_2_4_require_1_4"
    t.integer  "talent_3_1_require_2_1"
    t.integer  "talent_3_1_require_3_2"
    t.integer  "talent_3_2_require_2_2"
    t.integer  "talent_3_2_require_3_3"
    t.integer  "talent_3_3_require_2_3"
    t.integer  "talent_3_3_require_3_4"
    t.integer  "talent_3_4_require_2_4"
    t.integer  "talent_4_1_require_3_1"
    t.integer  "talent_4_1_require_4_2"
    t.integer  "talent_4_2_require_3_2"
    t.integer  "talent_4_2_require_4_3"
    t.integer  "talent_4_3_require_3_3"
    t.integer  "talent_4_3_require_4_4"
    t.integer  "talent_4_4_require_3_4"
    t.integer  "talent_5_1"
    t.integer  "talent_5_1_require_4_1"
    t.integer  "talent_5_1_require_5_2"
    t.integer  "talent_5_2"
    t.integer  "talent_5_2_require_4_2"
    t.integer  "talent_5_2_require_5_3"
    t.integer  "talent_5_3"
    t.integer  "talent_5_3_require_4_3"
    t.integer  "talent_5_3_require_5_4"
    t.integer  "talent_5_4"
    t.integer  "talent_5_4_require_4_4"
  end

  create_table "talents", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "activation"
    t.integer  "specialization_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "ranked"
  end

  create_table "users", force: true do |t|
    t.string   "username",               default: "",   null: false
    t.string   "email",                  default: "",   null: false
    t.string   "password_hash",          default: "",   null: false
    t.string   "password_salt",          default: "",   null: false
    t.string   "first_name",             default: "",   null: false
    t.string   "last_name",              default: "",   null: false
    t.string   "city",                   default: "",   null: false
    t.string   "state",                  default: "",   null: false
    t.string   "postal_code",            default: "",   null: false
    t.integer  "country_id",             default: 0,    null: false
    t.boolean  "enabled",                default: true, null: false
    t.text     "notes"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["enabled"], name: "index_users_on_enabled", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weapon_qualities", force: true do |t|
    t.string   "name"
    t.string   "trigger"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "weapon_quality_ranks", force: true do |t|
    t.integer  "weapon_id"
    t.integer  "weapon_quality_id"
    t.integer  "ranks"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "weapons", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "skill_id"
    t.integer  "damage"
    t.integer  "crit"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "range"
    t.integer  "encumbrance"
    t.integer  "hard_points"
    t.integer  "rarity"
  end

end
