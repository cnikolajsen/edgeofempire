class AddFreeRanksToCharacterSkills < ActiveRecord::Migration
  def change
    add_column :character_skills, :free_ranks_career, :integer
    add_column :character_skills, :free_ranks_specialization, :integer
    add_column :character_skills, :free_ranks_race, :integer
  end
end
