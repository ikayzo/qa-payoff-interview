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

ActiveRecord::Schema.define(version: 2020_01_29_002955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "borrowers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "debts", force: :cascade do |t|
    t.integer "borrower_id", null: false
    t.string "account_number"
    t.string "description"
    t.string "status"
    t.decimal "interest_rate"
    t.decimal "current_balance"
    t.decimal "outstanding_interest_amount"
    t.string "servicer_address"
    t.date "last_payment_date"
    t.decimal "last_payment_amount"
    t.decimal "last_statement_balance"
    t.date "last_statement_issue_date"
    t.date "next_payment_due_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
