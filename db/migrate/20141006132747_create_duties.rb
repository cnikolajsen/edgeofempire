class CreateDuties < ActiveRecord::Migration
  def change
    create_table :duties do |t|
      t.string :name
      t.text :description
      t.integer :career_id

      t.timestamps
    end
  end
end
