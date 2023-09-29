class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.string :student_name
      t.date :date
      t.time :start_time
      t.time :end_time
      t.string :parent_id
      t.string :student_id
      t.string :review
    end
  end
end