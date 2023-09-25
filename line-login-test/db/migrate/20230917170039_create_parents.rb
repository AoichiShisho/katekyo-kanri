class CreateParents < ActiveRecord::Migration[6.1]
  def change
    create_table :parents do |t|
      t.string :name
      t.string :img_url
      t.string :line_id
    end
  end
end
