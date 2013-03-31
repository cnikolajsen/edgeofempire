class CreateCharacterGears < ActiveRecord::Migration
  def change
    create_table :character_gears do |t|
      t.integer :character_id
      t.integer :gear_id
      t.integer :qty

      t.timestamps
    end
  end
end
