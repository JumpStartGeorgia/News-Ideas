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

ActiveRecord::Schema.define(:version => 20121109073901) do

  create_table "categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "category_translations", :force => true do |t|
    t.integer  "category_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_translations", ["category_id"], :name => "index_category_translations_on_category_id"
  add_index "category_translations", ["locale"], :name => "index_category_translations_on_locale"

  create_table "idea_categories", :force => true do |t|
    t.integer  "idea_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "idea_categories", ["category_id"], :name => "index_idea_categories_on_category_id"
  add_index "idea_categories", ["idea_id"], :name => "index_idea_categories_on_idea_id"

  create_table "idea_progresses", :force => true do |t|
    t.integer  "idea_id"
    t.integer  "organization_id"
    t.date     "progress_date"
    t.text     "explaination"
    t.boolean  "is_completed"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "idea_progresses", ["idea_id", "organization_id"], :name => "idea_prog_idea_org"
  add_index "idea_progresses", ["is_completed"], :name => "index_idea_progresses_on_is_completed"
  add_index "idea_progresses", ["progress_date"], :name => "index_idea_progresses_on_progress_date"

  create_table "ideas", :force => true do |t|
    t.integer  "user_id"
    t.text     "explaination"
    t.string   "individual_votes"
    t.integer  "overall_votes"
    t.boolean  "is_inappropriate", :default => false
    t.boolean  "is_duplicate",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ideas", ["is_inappropriate", "is_duplicate"], :name => "idea_must_hide"
  add_index "ideas", ["overall_votes"], :name => "index_ideas_on_overall_votes"
  add_index "ideas", ["user_id"], :name => "index_ideas_on_user_id"

  create_table "organization_translations", :force => true do |t|
    t.integer  "organization_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organization_translations", ["locale"], :name => "index_organization_translations_on_locale"
  add_index "organization_translations", ["organization_id"], :name => "index_b182f63d9a9aa74a99d1d5dca589cbf53f3a688c"

  create_table "organization_users", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.boolean  "is_active",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organization_users", ["is_active"], :name => "index_organization_users_on_is_active"
  add_index "organization_users", ["organization_id"], :name => "index_organization_users_on_organization_id"
  add_index "organization_users", ["user_id"], :name => "index_organization_users_on_user_id"

  create_table "organizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "user_favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_favorites", ["user_id"], :name => "index_user_favorites_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "role",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end