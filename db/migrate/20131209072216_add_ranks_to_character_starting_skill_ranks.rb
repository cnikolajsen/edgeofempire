class AddRanksToCharacterStartingSkillRanks < ActiveRecord::Migration
  def change
    add_column :character_starting_skill_ranks, :ranks, :integer
  end
end
