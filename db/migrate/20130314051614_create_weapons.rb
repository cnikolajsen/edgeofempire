class CreateWeapons < ActiveRecord::Migration
  def change
    create_table :weapons do |t|
      t.string :name
      t.text :description
      t.integer :skill_id
      t.integer :damage
      t.integer :crit
      t.integer :price

      t.timestamps
    end
  end
end
