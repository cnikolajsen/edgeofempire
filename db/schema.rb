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

ActiveRecord::Schema.define(version: 20150216083718) do

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

  create_table "adventure_logs", force: true do |t|
    t.datetime "date"
    t.text     "log"
    t.integer  "experience"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "adventure_logs", ["character_id"], name: "index_adventure_logs_on_character_id", using: :btree

  create_table "adventures", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "adversaries", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "brawn"
    t.integer  "agility"
    t.integer  "intellect"
    t.integer  "cunning"
    t.integer  "willpower"
    t.integer  "presence"
    t.integer  "soak"
    t.integer  "defense_ranged"
    t.integer  "defense_melee"
    t.integer  "wounds"
    t.integer  "strain"
    t.integer  "race_id"
    t.text     "abilities"
    t.string   "image_url"
    t.integer  "book_id"
    t.integer  "page"
    t.string   "adversary_type"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adversaries", ["slug"], name: "index_adversaries_on_slug", unique: true, using: :btree

  create_table "adversary_armor_attachments", force: true do |t|
    t.integer  "adversary_armor_id"
    t.integer  "armor_attachment_id"
    t.string   "armor_attachment_modification_options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adversary_armors", force: true do |t|
    t.integer  "adversary_id"
    t.integer  "armor_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adversary_weapon_attachments", force: true do |t|
    t.integer  "adversary_weapon_id"
    t.integer  "weapon_attachment_id"
    t.string   "weapon_attachment_modification_options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adversary_weapons", force: true do |t|
    t.integer  "adversary_id"
    t.integer  "weapon_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armor_attachment_attachments_groups", force: true do |t|
    t.integer  "armor_attachment_id"
    t.integer  "attachment_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armor_attachment_modification_options", force: true do |t|
    t.integer  "armor_attachment_id"
    t.integer  "talent_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armor_attachments", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "hard_points"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stat_bonus"
  end

  create_table "armor_attachments_armors", force: true do |t|
    t.integer  "armor_id"
    t.integer  "armor_attachment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "armor_attachments_armors", ["armor_attachment_id"], name: "index_armor_attachments_armors_on_armor_attachment_id", using: :btree
  add_index "armor_attachments_armors", ["armor_id"], name: "index_armor_attachments_armors_on_armor_id", using: :btree

  create_table "armor_attachments_groups", force: true do |t|
    t.integer  "armor_id"
    t.integer  "attachment_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armor_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armor_models", force: true do |t|
    t.integer  "armor_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armor_qualities", force: true do |t|
    t.string   "name"
    t.string   "trigger"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armor_quality_ranks", force: true do |t|
    t.integer  "armor_attachment_id"
    t.integer  "armor_quality_id"
    t.integer  "ranks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "armors", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "defense"
    t.integer  "soak"
    t.integer  "price"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "encumbrance"
    t.integer  "hard_points"
    t.integer  "rarity"
    t.string   "image_url"
    t.string   "slug"
    t.integer  "armor_category_id"
    t.integer  "book_id"
  end

  add_index "armors", ["book_id"], name: "index_armors_on_book_id", using: :btree
  add_index "armors", ["slug"], name: "index_armors_on_slug", unique: true, using: :btree

  create_table "attachment_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "system"
    t.string   "isbn"
    t.string   "category"
    t.string   "ffg_sku"
    t.string   "cover_art_url"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["slug"], name: "index_books_on_slug", unique: true, using: :btree

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

  create_table "career_talent_trees", force: true do |t|
    t.integer  "career_id"
    t.integer  "talent_tree_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "careers", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image_url"
    t.string   "slug"
  end

  add_index "careers", ["slug"], name: "index_careers_on_slug", unique: true, using: :btree

  create_table "character_armor_attachments", force: true do |t|
    t.integer  "character_armor_id"
    t.integer  "armor_attachment_id"
    t.string   "armor_attachment_modification_options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_armors", force: true do |t|
    t.integer  "character_id"
    t.integer  "armor_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "description"
    t.boolean  "equipped"
    t.boolean  "carried"
    t.integer  "armor_model_id"
    t.string   "custom_name"
  end

  create_table "character_bonus_talents", force: true do |t|
    t.integer  "character_id"
    t.integer  "talent_id"
    t.string   "bonus_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_criticals", force: true do |t|
    t.integer  "character_id"
    t.string   "effect"
    t.text     "description"
    t.integer  "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_criticals", ["character_id"], name: "index_character_criticals_on_character_id", using: :btree

  create_table "character_custom_gears", force: true do |t|
    t.integer  "character_id"
    t.string   "description"
    t.integer  "encumbrance"
    t.integer  "qty"
    t.boolean  "carried"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_cybernetics", force: true do |t|
    t.integer  "character_id"
    t.integer  "gear_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_duties", force: true do |t|
    t.integer  "character_id"
    t.integer  "duty_id"
    t.text     "description"
    t.integer  "magnitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_experience_costs", force: true do |t|
    t.integer  "character_id"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "cost"
    t.string   "granted_by"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_force_power_upgrades", force: true do |t|
    t.integer  "character_id"
    t.integer  "force_power_id"
    t.integer  "force_power_upgrade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_force_powers", force: true do |t|
    t.integer  "character_id"
    t.integer  "force_power_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_gears", force: true do |t|
    t.integer  "character_id"
    t.integer  "gear_id"
    t.integer  "qty"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "carried"
    t.integer  "gear_model_id"
  end

  create_table "character_motivations", force: true do |t|
    t.integer  "character_id"
    t.integer  "motivation_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_obligations", force: true do |t|
    t.integer  "character_id"
    t.integer  "obligation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "description"
    t.integer  "magnitude"
  end

  create_table "character_skills", force: true do |t|
    t.integer  "character_id"
    t.integer  "skill_id"
    t.integer  "ranks"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "free_ranks_career"
    t.integer  "free_ranks_specialization"
    t.integer  "free_ranks_race"
    t.integer  "free_ranks_equipment"
  end

  create_table "character_starting_skill_ranks", force: true do |t|
    t.integer  "character_id"
    t.integer  "skill_id"
    t.string   "granted_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ranks"
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

  create_table "character_weapon_attachments", force: true do |t|
    t.integer  "character_weapon_id"
    t.integer  "weapon_attachment_id"
    t.string   "weapon_attachment_modification_options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_weapons", force: true do |t|
    t.integer  "character_id"
    t.integer  "weapon_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "description"
    t.boolean  "equipped"
    t.boolean  "carried"
    t.integer  "weapon_model_id"
    t.string   "custom_name"
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
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
    t.text     "bio"
    t.integer  "credits"
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
    t.string   "image_url"
    t.string   "slug"
    t.string   "subspecies"
    t.integer  "campaign_id"
    t.integer  "strain",           default: 0
    t.integer  "wounds",           default: 0
    t.boolean  "staggered",        default: false
    t.boolean  "immobilized",      default: false
    t.boolean  "disoriented",      default: false
  end

  add_index "characters", ["slug"], name: "index_characters_on_slug", unique: true, using: :btree

  create_table "duties", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "career_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "force_power_upgrades", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "ranked"
    t.integer  "cost"
    t.integer  "row"
    t.integer  "column"
    t.integer  "colspan"
    t.integer  "parent_1"
    t.integer  "parent_2"
    t.integer  "force_power_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "force_powers", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "force_powers", ["slug"], name: "index_force_powers_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gear_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gear_models", force: true do |t|
    t.integer  "gear_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gears", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "encumbrance"
    t.integer  "rarity"
    t.string   "image_url"
    t.string   "slug"
    t.integer  "gear_category_id"
    t.integer  "book_id"
  end

  add_index "gears", ["book_id"], name: "index_gears_on_book_id", using: :btree
  add_index "gears", ["slug"], name: "index_gears_on_slug", unique: true, using: :btree

  create_table "motivations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "career_id"
  end

  create_table "obligations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "range"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "career_id"
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
    t.string   "image_url"
    t.string   "slug"
  end

  add_index "races", ["slug"], name: "index_races_on_slug", unique: true, using: :btree

  create_table "sidebars", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sidebars", ["slug"], name: "index_sidebars_on_slug", unique: true, using: :btree
  add_index "sidebars", ["title"], name: "index_sidebars_on_title", unique: true, using: :btree

  create_table "skills", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "characteristic"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "slug"
  end

  add_index "skills", ["slug"], name: "index_skills_on_slug", unique: true, using: :btree

  create_table "specializations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "career_id"
  end

  create_table "starship_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "starship_crews", force: true do |t|
    t.integer  "starship_id"
    t.string   "description"
    t.integer  "qty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "starship_crews", ["starship_id"], name: "index_starship_crews_on_starship_id", using: :btree

  create_table "starship_vehicle_weapons", force: true do |t|
    t.integer  "starship_id"
    t.integer  "vehicle_weapon_id"
    t.string   "mounting"
    t.string   "grouping"
    t.boolean  "turret"
    t.boolean  "retractable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "starship_vehicle_weapons", ["starship_id"], name: "index_starship_vehicle_weapons_on_starship_id", using: :btree
  add_index "starship_vehicle_weapons", ["vehicle_weapon_id"], name: "index_starship_vehicle_weapons_on_vehicle_weapon_id", using: :btree

  create_table "starships", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "silhouette"
    t.integer  "speed"
    t.integer  "handling"
    t.integer  "defense_fore"
    t.integer  "defense_port"
    t.integer  "defense_starboard"
    t.integer  "defense_aft"
    t.integer  "armor"
    t.integer  "hull_trauma_threshold"
    t.integer  "system_strain_threshold"
    t.integer  "hard_points"
    t.string   "hull_type"
    t.string   "manufacturer"
    t.integer  "hyperdrive_class_primary"
    t.integer  "hyperdrive_class_secondary"
    t.string   "navicomputer"
    t.string   "sensor_range"
    t.integer  "encumbrance_capacity"
    t.integer  "passenger_capacity"
    t.string   "consumables"
    t.integer  "cost"
    t.integer  "rarity"
    t.integer  "book_id"
    t.integer  "starship_category_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "starships", ["slug"], name: "index_starships_on_slug", unique: true, using: :btree

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
    t.string   "slug"
  end

  add_index "talent_trees", ["slug"], name: "index_talent_trees_on_slug", unique: true, using: :btree

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
    t.string   "slug"
    t.string   "provider"
    t.string   "uid"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["enabled"], name: "index_users_on_enabled", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "vehicle_weapons", force: true do |t|
    t.string   "name"
    t.string   "range"
    t.integer  "damage"
    t.integer  "critical"
    t.integer  "price"
    t.integer  "rarity"
    t.integer  "size_low"
    t.integer  "size_high"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicle_weapons", ["slug"], name: "index_vehicle_weapons_on_slug", unique: true, using: :btree

  create_table "weapon_attachment_attachments_groups", force: true do |t|
    t.integer  "weapon_attachment_id"
    t.integer  "attachment_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weapon_attachment_modification_options", force: true do |t|
    t.integer  "weapon_attachment_id"
    t.integer  "talent_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "damage_bonus"
    t.integer  "weapon_quality_id"
    t.integer  "weapon_quality_rank"
    t.string   "custom"
  end

  create_table "weapon_attachment_quality_ranks", force: true do |t|
    t.integer  "weapon_attachment_id"
    t.integer  "weapon_quality_id"
    t.integer  "ranks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weapon_attachments", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "hard_points"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "damage_bonus"
  end

  create_table "weapon_attachments_groups", force: true do |t|
    t.integer  "weapon_id"
    t.integer  "attachment_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weapon_attachments_weapons", force: true do |t|
    t.integer  "weapon_id"
    t.integer  "weapon_attachment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weapon_attachments_weapons", ["weapon_attachment_id"], name: "index_weapon_attachments_weapons_on_weapon_attachment_id", using: :btree
  add_index "weapon_attachments_weapons", ["weapon_id"], name: "index_weapon_attachments_weapons_on_weapon_id", using: :btree

  create_table "weapon_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weapon_models", force: true do |t|
    t.integer  "weapon_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "range"
    t.integer  "encumbrance"
    t.integer  "hard_points"
    t.integer  "rarity"
    t.string   "image_url"
    t.string   "slug"
    t.integer  "weapon_category_id"
    t.integer  "book_id"
  end

  add_index "weapons", ["book_id"], name: "index_weapons_on_book_id", using: :btree
  add_index "weapons", ["slug"], name: "index_weapons_on_slug", unique: true, using: :btree

end
