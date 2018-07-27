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

ActiveRecord::Schema.define(version: 20180727205027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.date "joined_on"
    t.bigint "leader_id"
    t.index ["joined_on"], name: "index_employees_on_joined_on"
    t.index ["leader_id"], name: "index_employees_on_leader_id"
  end

  create_table "paychecks", force: :cascade do |t|
    t.bigint "employee_id"
    t.integer "year", limit: 2
    t.integer "month", limit: 2
    t.date "paid_on"
    t.integer "payment_cents", default: 0, null: false
    t.string "payment_currency", default: "EUR", null: false
    t.integer "bonus_cents", default: 0, null: false
    t.string "bonus_currency", default: "EUR", null: false
    t.bigint "position_id"
    t.index ["employee_id"], name: "index_paychecks_on_employee_id"
    t.index ["position_id"], name: "index_paychecks_on_position_id"
    t.index ["year", "month", "employee_id"], name: "index_paychecks_on_year_and_month_and_employee_id", unique: true
  end

  create_table "positions", force: :cascade do |t|
    t.string "title"
  end

  create_table "product_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "price_net_cents", default: 0, null: false
    t.string "price_net_currency", default: "EUR", null: false
    t.integer "price_with_tax_cents", default: 0, null: false
    t.string "price_with_tax_currency", default: "EUR", null: false
    t.integer "cost_of_production_cents", default: 0, null: false
    t.string "cost_of_production_currency", default: "EUR", null: false
    t.date "for_sale_since"
  end

  create_table "products_product_types", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "product_type_id"
    t.index ["product_id", "product_type_id"], name: "index_products_product_types_on_product_id_and_product_type_id", unique: true
    t.index ["product_id"], name: "index_products_product_types_on_product_id"
    t.index ["product_type_id"], name: "index_products_product_types_on_product_type_id"
  end

  create_table "products_sales", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "sale_id"
    t.integer "amount"
    t.index ["product_id", "sale_id"], name: "index_products_sales_on_product_id_and_sale_id", unique: true
    t.index ["product_id"], name: "index_products_sales_on_product_id"
    t.index ["sale_id"], name: "index_products_sales_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "employees_id"
    t.bigint "seller_id"
    t.date "sold_on"
    t.integer "discount_cents", default: 0, null: false
    t.string "discount_currency", default: "EUR", null: false
    t.index ["employees_id"], name: "index_sales_on_employees_id"
    t.index ["seller_id"], name: "index_sales_on_seller_id"
    t.index ["sold_on"], name: "index_sales_on_sold_on"
  end

  add_foreign_key "employees", "employees", column: "leader_id"
  add_foreign_key "paychecks", "employees"
  add_foreign_key "paychecks", "positions"
  add_foreign_key "products_product_types", "product_types"
  add_foreign_key "products_product_types", "products"
  add_foreign_key "products_sales", "products"
  add_foreign_key "products_sales", "sales"
  add_foreign_key "sales", "employees", column: "employees_id"
  add_foreign_key "sales", "employees", column: "seller_id"
end
