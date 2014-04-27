class CreateCharacterForcePowers < ActiveRecord::Migration
  def change
    create_table :character_force_powers do |t|
      t.integer :character_id
      t.integer :force_power_id

      t.timestamps
    end
  end
end
