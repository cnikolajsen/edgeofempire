class CreateCharacterDuties < ActiveRecord::Migration
  def change
    create_table :character_duties do |t|
      t.integer :character_id
      t.integer :duty_id
      t.text :description
      t.integer :magnitude

      t.timestamps
    end
  end
end
