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

ActiveRecord::Schema.define(:version => 20160627053246) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0,  :null => false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["confirmation_token"], :name => "index_admin_users_on_confirmation_token", :unique => true
  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true
  add_index "admin_users", ["unlock_token"], :name => "index_admin_users_on_unlock_token", :unique => true

  create_table "asteroids", :force => true do |t|
    t.string   "designation"
    t.datetime "close_app_date"
    t.decimal  "close_app_dist"
    t.float    "impact_prob_float"
    t.decimal  "impact_prob"
    t.string   "taxonomy_class"
    t.boolean  "pha"
    t.decimal  "size"
    t.decimal  "spin_period"
    t.decimal  "delta_v"
    t.decimal  "period"
    t.string   "orbit_url"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "editions", :force => true do |t|
    t.string   "state"
    t.string   "title"
    t.integer  "theme_id"
    t.integer  "flyby_id"
    t.integer  "orbit_diagram_id"
    t.integer  "news_story_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "publish_date"
    t.integer  "total_shares"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "editions", ["created_by_id"], :name => "index_editions_on_created_by_id"
  add_index "editions", ["flyby_id"], :name => "index_editions_on_flyby_id"
  add_index "editions", ["news_story_id"], :name => "index_editions_on_news_story_id"
  add_index "editions", ["orbit_diagram_id"], :name => "index_editions_on_orbit_diagram_id"
  add_index "editions", ["theme_id"], :name => "index_editions_on_theme_id"
  add_index "editions", ["updated_by_id"], :name => "index_editions_on_updated_by_id"

  create_table "flybys", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "flybys", ["created_by_id"], :name => "index_flybys_on_created_by_id"
  add_index "flybys", ["updated_by_id"], :name => "index_flybys_on_updated_by_id"

  create_table "news_stories", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "story_url"
    t.integer  "source_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "news_stories", ["created_by_id"], :name => "index_news_stories_on_created_by_id"
  add_index "news_stories", ["source_id"], :name => "index_news_stories_on_source_id"
  add_index "news_stories", ["updated_by_id"], :name => "index_news_stories_on_updated_by_id"

  create_table "orbit_diagrams", :force => true do |t|
    t.string   "title"
    t.integer  "asteroid_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "orbit_diagrams", ["asteroid_id"], :name => "index_orbit_diagrams_on_asteroid_id"
  add_index "orbit_diagrams", ["created_by_id"], :name => "index_orbit_diagrams_on_created_by_id"
  add_index "orbit_diagrams", ["updated_by_id"], :name => "index_orbit_diagrams_on_updated_by_id"

  create_table "preferences", :force => true do |t|
    t.integer  "subscription_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "preferences", ["subscription_id"], :name => "index_preferences_on_subscription_id"

  create_table "social_engagements", :force => true do |t|
    t.integer  "edition_id"
    t.string   "social_type"
    t.integer  "count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "social_engagements", ["edition_id"], :name => "index_social_engagements_on_edition_id"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "themes", ["created_by_id"], :name => "index_themes_on_created_by_id"
  add_index "themes", ["updated_by_id"], :name => "index_themes_on_updated_by_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "roles_mask"
    t.string   "username"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
