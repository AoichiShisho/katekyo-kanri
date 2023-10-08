class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :student_id
      t.integer :parent_id
      t.integer :teacher_id
      t.string :review
    end
  end
end