class CreateCharacterStartingSkillRanks < ActiveRecord::Migration
  def change
    create_table :character_starting_skill_ranks do |t|
      t.integer :character_id
      t.integer :skill_id
      t.string :granted_by

      t.timestamps
    end
  end
end
