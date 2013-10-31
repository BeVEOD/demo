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

ActiveRecord::Schema.define(:version => 20130708081635) do

  create_table "accesses", :force => true do |t|
    t.string  "set_sid",           :limit => 50
    t.string  "table_sid"
    t.string  "field_sid",         :limit => 80
    t.string  "action_sid",        :limit => 60
    t.string  "type_sid",          :limit => 20
    t.string  "app_sid",           :limit => 100
    t.integer "system_setting_id"
    t.string  "aktion_sid"
  end

  add_index "accesses", ["system_setting_id"], :name => "index_accesses_on_system_setting_id"

  create_table "advanced_searches", :force => true do |t|
    t.string  "name"
    t.string  "table_name"
    t.text    "criteria"
    t.boolean "case_sensitive"
  end

  create_table "app_locales", :force => true do |t|
    t.string   "locale_code"
    t.string   "po__name"
    t.binary   "po"
    t.datetime "updated_at"
  end

  create_table "bg_workers", :force => true do |t|
    t.string   "name"
    t.text     "launch"
    t.text     "task"
    t.integer  "version",             :limit => 3
    t.string   "every"
    t.integer  "priority"
    t.integer  "attempts"
    t.string   "locked_by"
    t.datetime "planned_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.datetime "created_at"
    t.text     "payload"
    t.datetime "from"
    t.string   "cron"
    t.integer  "triggered_by"
    t.datetime "started_at"
    t.integer  "last_return_code"
    t.boolean  "no_duplicate"
    t.text     "logs"
    t.string   "start_cond_overview"
    t.datetime "completed_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",                         :default => 0
    t.integer  "attempts",                         :default => 0
    t.text     "handler",    :limit => 2147483647
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dev_feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.string   "title"
    t.text     "text"
    t.string   "url"
    t.string   "controller"
    t.string   "action"
    t.integer  "ticket_status"
    t.text     "zone"
    t.integer  "rgt"
    t.integer  "lft"
    t.integer  "parent_id"
    t.string   "ip"
    t.string   "ua"
    t.text     "browser"
  end

  create_table "file_imports", :force => true do |t|
    t.integer  "user_id"
    t.text     "log"
    t.string   "file__name"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "progress"
    t.integer  "expected_total"
    t.integer  "error_count"
    t.integer  "file_import_id"
  end

  create_table "importers", :force => true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.integer  "source_type"
    t.string   "host"
    t.string   "adapter"
    t.string   "user_name"
    t.string   "data_base"
    t.string   "password"
    t.integer  "port"
    t.string   "file__name"
  end

  create_table "profile_accesses", :force => true do |t|
    t.integer "profile_id"
    t.integer "access_id"
    t.boolean "read"
    t.boolean "write"
  end

  add_index "profile_accesses", ["access_id"], :name => "index_profile_accesses_on_access_id"
  add_index "profile_accesses", ["profile_id"], :name => "index_profile_accesses_on_profile_id"

  create_table "profiles", :force => true do |t|
    t.string  "name",         :limit => 100
    t.integer "home_page_id"
  end

  add_index "profiles", ["home_page_id"], :name => "index_profiles_on_access_id"

  create_table "profiles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "profile_id"
  end

  add_index "profiles_users", ["user_id", "profile_id"], :name => "index_profiles_users_on_user_id_and_profile_id"

  create_table "promoters", :force => true do |t|
    t.string "new_string"
  end

  create_table "saved_reports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.string   "url"
    t.text     "data"
  end

  create_table "smart_queries", :force => true do |t|
    t.string  "name"
    t.text    "criteria"
    t.string  "table_sid"
    t.integer "joining_criteria"
  end

  create_table "system_settings", :force => true do |t|
    t.string "name"
    t.text   "value"
  end

  create_table "uncatched_exceptions", :force => true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
    t.string   "new_string"
    t.text     "new_text"
    t.datetime "new_datetime"
  end

  create_table "user_accesses", :force => true do |t|
    t.integer "access_id"
    t.integer "user_id"
    t.boolean "read"
    t.boolean "write"
  end

  add_index "user_accesses", ["access_id"], :name => "index_user_accesses_on_access_id"
  add_index "user_accesses", ["user_id"], :name => "index_user_accesses_on_user_id"

  create_table "user_settings", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.text    "value"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "active"
    t.string   "salt"
    t.string   "hashed_password"
    t.datetime "last_login"
    t.string   "last_session_id"
    t.string   "language"
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.string   "authorized_ips"
    t.text     "next_step"
    t.string   "tel"
    t.integer  "version"
    t.string   "fonction"
  end

  add_index "users", ["version"], :name => "index_users_on_version"

  create_table "users_versions", :force => true do |t|
    t.integer  "fk_user_id"
    t.integer  "version"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "fonction"
    t.string   "email"
    t.string   "language"
    t.text     "next_step"
    t.boolean  "active"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "last_login"
    t.string   "last_session_id"
    t.integer  "user_id"
    t.integer  "profile_id"
  end

  add_index "users_versions", ["fk_user_id"], :name => "index_users_versions_on_fk_user_id"
  add_index "users_versions", ["version"], :name => "index_users_versions_on_version"

end
