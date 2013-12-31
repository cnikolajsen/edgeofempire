class AddEquippedAndHeldToCharacterArmors < ActiveRecord::Migration
  def change
    add_column :character_armors, :equipped, :boolean
    add_column :character_armors, :carried, :boolean
  end
end
