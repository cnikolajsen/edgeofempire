class AddArmorModelToCharacterArmors < ActiveRecord::Migration
  def change
    add_column :character_armors, :armor_model_id, :integer
  end
end
