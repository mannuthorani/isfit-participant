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

ActiveRecord::Schema.define(:version => 20120911172113) do

  create_table "answers", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "question_id"
    t.text     "content"
    t.integer  "user_id"
  end

  create_table "arrival_places", :force => true do |t|
    t.string "name"
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "functionary_id"
    t.datetime "publish_at"
    t.integer  "user_id"
    t.integer  "sticky"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.string   "code",       :limit => 4
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "deadlines", :force => true do |t|
    t.datetime "deadline"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deadlines_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "deadline_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "functionaries", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "functionaries_participants", :id => false, :force => true do |t|
    t.integer  "functionary_id"
    t.integer  "participant_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "hosts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "information_categories", :force => true do |t|
    t.string "title"
  end

  create_table "information_pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "information_category_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "participants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.date     "date_of_birth"
    t.string   "address1"
    t.string   "address2"
    t.integer  "zipcode"
    t.string   "city"
    t.integer  "country_id"
    t.integer  "sex"
    t.string   "field_of_study"
    t.integer  "workshop_id"
    t.integer  "user_id"
    t.integer  "functionary_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.datetime "arrives_at"
    t.datetime "departs_at"
    t.integer  "arrival_place_id"
    t.integer  "need_transport"
    t.string   "next_of_kin_name"
    t.string   "next_of_kin_phone"
    t.text     "next_of_kin_address"
    t.integer  "flightnumber"
    t.integer  "has_passport"
    t.integer  "accepted"
    t.integer  "visa"
    t.integer  "transport_type_id"
    t.integer  "travel_support"
    t.integer  "applied_for_visa"
    t.integer  "notified"
    t.boolean  "dialogue"
    t.string   "middle_name"
    t.boolean  "media_consent"
    t.boolean  "subscribe_consent"
    t.integer  "embassy_confirmation"
    t.boolean  "allergy_lactose"
    t.boolean  "allergy_gluten"
    t.boolean  "allergy_nuts"
    t.string   "allergy_other"
    t.boolean  "vegetarian"
    t.boolean  "guaranteed"
    t.boolean  "smoke"
    t.string   "handicap"
    t.boolean  "allergy_pets"
    t.integer  "host_id"
    t.datetime "checked_in"
    t.datetime "checked_out"
    t.boolean  "spp"
  end

  create_table "question_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "dialogue"
    t.integer  "participant_id"
    t.integer  "question_status_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "question_id"
  end

  create_table "regions", :force => true do |t|
    t.string "name"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "roles", ["authorizable_id"], :name => "index_roles_on_authorizable_id"
  add_index "roles", ["authorizable_type"], :name => "index_roles_on_authorizable_type"
  add_index "roles", ["name", "authorizable_id", "authorizable_type"], :name => "index_roles_on_name_and_authorizable_id_and_authorizable_type", :unique => true
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "roles_views", :id => false, :force => true do |t|
    t.integer "id",                              :default => 0, :null => false
    t.integer "user_id"
    t.string  "name",              :limit => 40
    t.string  "authorizable_type", :limit => 40
    t.integer "authorizable_id"
  end

  create_table "transport_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "first_password"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workshops", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  add_foreign_key "roles_users", "roles", :name => "roles_users_role_id_fk"
  add_foreign_key "roles_users", "users", :name => "roles_users_user_id_fk"

end
