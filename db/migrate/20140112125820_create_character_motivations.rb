class CreateCharacterMotivations < ActiveRecord::Migration
  def change
    create_table :character_motivations do |t|
      t.integer :character_id
      t.integer :motivation_id
      t.text :description

      t.timestamps
    end
  end
end
