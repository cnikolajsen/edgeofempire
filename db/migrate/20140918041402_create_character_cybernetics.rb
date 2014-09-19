class CreateCharacterCybernetics < ActiveRecord::Migration
  def change
    create_table :character_cybernetics do |t|
      t.integer :character_id
      t.integer :gear_id
      t.string :location

      t.timestamps
    end
  end
end
