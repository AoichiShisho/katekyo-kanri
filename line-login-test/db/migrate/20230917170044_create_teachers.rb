class CreateTeachers < ActiveRecord::Migration[6.1]
  def change
    create_table :teachers do |t|
      t.string :name
      t.string :img_url
      t.integer :line_id
      t.string :bank_name
      t.string :branch_name
      t.integer :account_num
    end
  end
end
