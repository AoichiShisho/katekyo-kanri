# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_10_01_070215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "grades", force: :cascade do |t|
    t.integer "grade_number"
    t.string "label"
  end

  create_table "parents", force: :cascade do |t|
    t.string "name"
    t.string "img_url"
    t.string "line_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.integer "student_id"
    t.integer "parent_id"
    t.integer "teacher_id"
    t.string "review"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.integer "grade_id"
    t.string "school"
    t.integer "parent_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
    t.string "img_url"
    t.integer "line_id"
    t.string "bank_name"
    t.string "branch_name"
    t.integer "account_num"
  end

end
