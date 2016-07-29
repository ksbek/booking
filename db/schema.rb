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

ActiveRecord::Schema.define(version: 20160630194548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "postcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_primary", default: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "arts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
    t.text     "main_description"
    t.text     "italic_description"
    t.text     "banner_url"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "status"
    t.datetime "date"
    t.integer  "spectators"
    t.float    "price"
    t.text     "message"
    t.float    "payout"
    t.boolean  "payment_received?"
    t.boolean  "payment_sent?"
    t.datetime "paid_on"
    t.datetime "paid_out_on"
    t.integer  "show_id"
    t.integer  "user_id"
    t.integer  "address_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "payment_method_id"
    t.integer  "credit_card_id"
  end

  add_index "bookings", ["address_id"], name: "index_bookings_on_address_id", using: :btree
  add_index "bookings", ["credit_card_id"], name: "index_bookings_on_credit_card_id", using: :btree
  add_index "bookings", ["payment_method_id"], name: "index_bookings_on_payment_method_id", using: :btree
  add_index "bookings", ["show_id"], name: "index_bookings_on_show_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "credit_cards", force: :cascade do |t|
    t.string   "brand"
    t.string   "country"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.string   "funding"
    t.string   "last4"
    t.string   "stripe_id"
    t.boolean  "default",    default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages_users", force: :cascade do |t|
    t.integer "language_id"
    t.integer "user_id"
  end

  add_index "languages_users", ["language_id"], name: "index_languages_users_on_language_id", using: :btree
  add_index "languages_users", ["user_id"], name: "index_languages_users_on_user_id", using: :btree

  create_table "payment_methods", force: :cascade do |t|
    t.integer "user_id"
    t.integer "booking_id"
    t.string  "stripe_token"
    t.string  "last4"
  end

  add_index "payment_methods", ["booking_id"], name: "index_payment_methods_on_booking_id", using: :btree
  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "title"
    t.boolean  "selected"
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pictures", ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "value"
    t.integer  "review_id"
    t.integer  "user_id"
    t.integer  "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ratings", ["booking_id"], name: "index_ratings_on_booking_id", using: :btree
  add_index "ratings", ["review_id"], name: "index_ratings_on_review_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.text     "review"
    t.integer  "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reviews", ["booking_id"], name: "index_reviews_on_booking_id", using: :btree

  create_table "user_availabilities", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "available_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role",                   default: 1
    t.string   "firstname"
    t.string   "surname"
    t.integer  "gender"
    t.text     "bio"
    t.string   "phone_number"
    t.date     "dob"
    t.string   "activity"
    t.boolean  "moving"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "profile_picture_id"
    t.string   "nickname"
    t.string   "customer_id"
    t.string   "stripe_pub_key"
    t.string   "stripe_user_id"
    t.string   "stripe_access_code"
    t.integer  "art_id"
  end

  add_index "users", ["art_id"], name: "index_users_on_art_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["profile_picture_id"], name: "index_users_on_profile_picture_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "bookings", "credit_cards"
  add_foreign_key "bookings", "payment_methods"
  add_foreign_key "payment_methods", "bookings"
  add_foreign_key "payment_methods", "users"
  add_foreign_key "users", "arts"
end
