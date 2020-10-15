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

ActiveRecord::Schema.define(version: 2020_10_15_120301) do

  create_table "inventory_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "current_price", null: false
    t.integer "available_quantity", null: false
    t.integer "reserved_quantity", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders_contact_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "orders_order_id", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["orders_order_id"], name: "index_orders_contact_infos_on_orders_order_id"
  end

  create_table "orders_order_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "orders_order_id", null: false
    t.bigint "inventory_product_id", null: false
    t.integer "quantity", null: false
    t.boolean "reserved", default: false, null: false
    t.integer "price_at_submit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventory_product_id"], name: "index_orders_order_lines_on_inventory_product_id"
    t.index ["orders_order_id"], name: "index_orders_order_lines_on_orders_order_id"
  end

  create_table "orders_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "state", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders_shipping_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "orders_order_id", null: false
    t.string "receiver_name", null: false
    t.text "shipping_address", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["orders_order_id"], name: "index_orders_shipping_infos_on_orders_order_id"
  end

  create_table "payments_credit_card_payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "orders_order_id", null: false
    t.integer "amount", null: false
    t.string "state", null: false
    t.string "transaction_identifier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["orders_order_id"], name: "index_payments_credit_card_payments_on_orders_order_id"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "orders_contact_infos", "orders_orders"
  add_foreign_key "orders_order_lines", "inventory_products"
  add_foreign_key "orders_order_lines", "orders_orders"
  add_foreign_key "orders_shipping_infos", "orders_orders"
  add_foreign_key "payments_credit_card_payments", "orders_orders"
end
