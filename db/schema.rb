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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120417211031) do

  create_table "answers", :force => true do |t|
    t.text     "response"
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "invite_codes", :force => true do |t|
    t.string   "code"
    t.string   "audience"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invite_requests", :force => true do |t|
    t.string   "email"
    t.string   "zip_code"
    t.text     "comments"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "movies", :force => true do |t|
    t.string   "TMSId"
    t.string   "title"
    t.text     "desc_long"
    t.text     "genre"
    t.string   "rating"
    t.date     "release_dt"
    t.string   "trailer_url"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
  end

  add_index "movies", ["TMSId"], :name => "index_movies_on_TMSId"

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schedules", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "theater_id"
    t.datetime "showing_dt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "schedules", ["movie_id"], :name => "index_schedules_on_movie_id"
  add_index "schedules", ["theater_id"], :name => "index_schedules_on_theater_id"

  create_table "theaters", :force => true do |t|
    t.string   "theatreId"
    t.string   "name"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.integer  "address_zip"
    t.string   "address_country"
    t.string   "telephone"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "theaters", ["theatreId"], :name => "index_theaters_on_theatreId"

  create_table "user_images", :force => true do |t|
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "caption"
    t.boolean  "is_profile_pic"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname",                                 :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "gender",                                    :null => false
    t.string   "orientation",                               :null => false
    t.integer  "zipcode",                                   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.datetime "birthdate"
    t.boolean  "is_admin",               :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "watch_list_preferred_theaters", :force => true do |t|
    t.integer  "watch_list_id"
    t.integer  "theater_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "watch_list_preferred_theaters", ["watch_list_id", "theater_id"], :name => "index_uniq_wlpt_wl_theater", :unique => true

  create_table "watch_lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "movie_id"
    t.text     "note"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "watch_lists", ["user_id", "movie_id"], :name => "index_uniq_wl_user_movie", :unique => true

  create_table "zip_locs", :force => true do |t|
    t.integer  "zip"
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
