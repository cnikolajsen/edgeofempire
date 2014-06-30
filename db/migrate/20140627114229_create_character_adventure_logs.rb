class CreateCharacterAdventureLogs < ActiveRecord::Migration
  def change
    create_table :character_adventure_logs do |t|
      t.datetime :date
      t.text :log
      t.integer :experience

      # This line adds an integer column called `character_id`.
      t.references :character, index: true

      t.timestamps
    end
  end
end
