class CreateCharacterCriticals < ActiveRecord::Migration
  def change
    create_table :character_criticals do |t|
      t.integer :character_id
      t.string :effect
      t.text :description
      t.integer :severity

      t.timestamps
    end

    add_index 'character_criticals', ['character_id'], name: 'index_character_criticals_on_character_id'
  end
end
