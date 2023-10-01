class CreateGrades < ActiveRecord::Migration[6.1]
  def change
    create_table :grades do |t|
      t.integer :grade_number
      t.string :label
    end
  end
end
