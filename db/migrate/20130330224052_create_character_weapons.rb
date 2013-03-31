class CreateCharacterWeapons < ActiveRecord::Migration
  def change
    create_table :character_weapons do |t|
      t.integer :character_id
      t.integer :weapon_id

      t.timestamps
    end
  end
end
