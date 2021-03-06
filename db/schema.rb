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

ActiveRecord::Schema.define(version: 2020_06_07_152455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.text "content", default: "", null: false
    t.bigint "question_id", null: false
    t.bigint "user_id", null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "net_upvotes", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "marked_abuse", default: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "api_requests", force: :cascade do |t|
    t.string "client_ip", default: "", null: false
    t.string "path", default: "/api/", null: false
    t.datetime "created_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", default: "", null: false
    t.bigint "user_id", null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "net_upvotes", default: 0, null: false
    t.boolean "marked_abuse", default: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "credit_transactions", force: :cascade do |t|
    t.integer "credits", default: 0, null: false
    t.text "reason", default: "other", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "creditable_type"
    t.bigint "creditable_id"
    t.index ["creditable_type", "creditable_id"], name: "index_credit_transactions_on_creditable_type_and_creditable_id"
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "message", default: "", null: false
    t.boolean "viewed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.integer "credits", default: 0, null: false
    t.bigint "purchase_pack_id", null: false
    t.bigint "user_id", null: false
    t.decimal "amount", default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.string "stripe_token"
    t.string "charge_id"
    t.string "error_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "paid_at"
    t.datetime "refunded_at"
    t.jsonb "charge_response", default: {}, null: false
    t.index ["purchase_pack_id"], name: "index_payment_transactions_on_purchase_pack_id"
    t.index ["user_id"], name: "index_payment_transactions_on_user_id"
  end

  create_table "purchase_packs", force: :cascade do |t|
    t.integer "pack_type", default: 0, null: false
    t.string "name", default: "", null: false
    t.integer "credits", default: 0, null: false
    t.decimal "original_price", default: "0.0", null: false
    t.decimal "current_price", default: "0.0", null: false
    t.string "image", default: "", null: false
    t.string "description", default: "", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.text "content", default: "", null: false
    t.bigint "user_id", null: false
    t.datetime "published_at"
    t.bigint "comments_count", default: 0, null: false
    t.bigint "answers_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "net_upvotes", default: 0, null: false
    t.boolean "marked_abuse", default: false
    t.index ["title"], name: "index_questions_on_title", unique: true
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "questions_topics", id: false, force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_questions_topics_on_question_id"
    t.index ["topic_id"], name: "index_questions_topics_on_topic_id"
  end

  create_table "spams", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "spammable_type"
    t.bigint "spammable_id"
    t.string "reason", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spammable_type", "spammable_id"], name: "index_spams_on_spammable_type_and_spammable_id"
    t.index ["user_id"], name: "index_spams_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name", default: "other", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_topics_on_name", unique: true
  end

  create_table "topics_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_id"], name: "index_topics_users_on_topic_id"
    t.index ["user_id"], name: "index_topics_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin", default: false, null: false
    t.integer "credits", default: 0, null: false
    t.boolean "active", default: false, null: false
    t.string "confirm_token"
    t.string "reset_token"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "new_notifications_count", default: 0, null: false
    t.string "stripe_token"
    t.string "auth_token"
    t.index ["confirm_token"], name: "index_users_on_confirm_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_token"], name: "index_users_on_reset_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "vote_type", default: 0, null: false
    t.string "votable_type"
    t.bigint "votable_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "payment_transactions", "purchase_packs"
  add_foreign_key "payment_transactions", "users"
  add_foreign_key "questions", "users"
  add_foreign_key "spams", "users"
  add_foreign_key "votes", "users"
end
