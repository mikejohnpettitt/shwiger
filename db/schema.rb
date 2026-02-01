# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_01_28_085505) do
  create_table "cards", force: :cascade do |t|
    t.integer "deck_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_id", null: false
    t.boolean "temporary"
    t.index ["deck_id"], name: "index_cards_on_deck_id"
    t.index ["entry_id"], name: "index_cards_on_entry_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "definitions", force: :cascade do |t|
    t.integer "entry_id", null: false
    t.string "english"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_definitions_on_entry_id"
  end

  create_table "entries", force: :cascade do |t|
    t.string "chinese"
    t.string "pinyin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "wubi"
  end

  create_table "entry_similarities", force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "similar_entry_id", null: false
    t.string "similarity_type"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_entry_similarities_on_entry_id"
    t.index ["similar_entry_id"], name: "index_entry_similarities_on_similar_entry_id"
    t.index ["user_id"], name: "index_entry_similarities_on_user_id"
  end

  create_table "study_session_decks", force: :cascade do |t|
    t.integer "study_session_id", null: false
    t.integer "deck_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_study_session_decks_on_deck_id"
    t.index ["study_session_id"], name: "index_study_session_decks_on_study_session_id"
  end

  create_table "study_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mode"
    t.index ["user_id"], name: "index_study_sessions_on_user_id"
  end

  create_table "user_cards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "card_id", null: false
    t.integer "preferred_definition_id", null: false
    t.float "retention_definition"
    t.datetime "last_reviewed_definition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "next_review_definition"
    t.float "retention_pinyin"
    t.datetime "last_reviewed_pinyin"
    t.datetime "next_review_pinyin"
    t.integer "session_review_tally"
    t.integer "forgetability_definition"
    t.integer "forgetability_pinyin"
    t.index ["card_id"], name: "index_user_cards_on_card_id"
    t.index ["preferred_definition_id"], name: "index_user_cards_on_preferred_definition_id"
    t.index ["user_id"], name: "index_user_cards_on_user_id"
  end

  create_table "user_decks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "deck_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_user_decks_on_deck_id"
    t.index ["user_id"], name: "index_user_decks_on_user_id"
  end

  create_table "user_entry_similarities", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "entry_similarity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_similarity_id"], name: "index_user_entry_similarities_on_entry_similarity_id"
    t.index ["user_id"], name: "index_user_entry_similarities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cards", "decks"
  add_foreign_key "cards", "entries"
  add_foreign_key "decks", "users"
  add_foreign_key "definitions", "entries"
  add_foreign_key "entry_similarities", "entries"
  add_foreign_key "entry_similarities", "entries", column: "similar_entry_id"
  add_foreign_key "entry_similarities", "users"
  add_foreign_key "study_session_decks", "decks"
  add_foreign_key "study_session_decks", "study_sessions"
  add_foreign_key "study_sessions", "users"
  add_foreign_key "user_cards", "cards"
  add_foreign_key "user_cards", "definitions", column: "preferred_definition_id"
  add_foreign_key "user_cards", "users"
  add_foreign_key "user_decks", "decks"
  add_foreign_key "user_decks", "users"
  add_foreign_key "user_entry_similarities", "entry_similarities"
  add_foreign_key "user_entry_similarities", "users"
end
