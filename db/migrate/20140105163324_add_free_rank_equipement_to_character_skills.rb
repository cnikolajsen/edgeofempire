class AddFreeRankEquipementToCharacterSkills < ActiveRecord::Migration
  def change
    add_column :character_skills, :free_ranks_equipment, :integer
  end
end
