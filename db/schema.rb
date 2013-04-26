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

<<<<<<< HEAD
ActiveRecord::Schema.define(:version => 20130411224843) do
=======
ActiveRecord::Schema.define(:version => 20130425183735) do
>>>>>>> 8b0bf0112c3e7559272a3f607c64e258039c21af

  create_table "games", :force => true do |t|
    t.integer  "manager_id"
    t.integer  "winner_id"
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "budget"
    t.boolean  "is_terminated", :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "game_id"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "purchased_stocks", :force => true do |t|
    t.integer  "user_game_id"
    t.string   "stock_code"
    t.integer  "total_qty",       :default => 0
    t.integer  "money_spent",     :default => 0
    t.integer  "money_earned",    :default => 0
    t.integer  "value_in_stocks", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "purchased_stock_id"
    t.datetime "date"
    t.integer  "qty"
    t.integer  "value_per_stock"
    t.boolean  "is_buy"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "user_games", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "balance",               :default => 0
    t.integer  "points",                :default => 0
    t.integer  "total_value_in_stocks", :default => 0
    t.boolean  "is_active",             :default => true
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "email"
    t.integer  "total_points",           :default => 0
    t.boolean  "is_admin",               :default => false
    t.boolean  "is_active",              :default => true
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "auth_token"
  end

end
