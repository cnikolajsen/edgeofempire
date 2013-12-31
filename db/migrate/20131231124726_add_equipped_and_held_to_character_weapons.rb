class AddEquippedAndHeldToCharacterWeapons < ActiveRecord::Migration
  def change
    add_column :character_weapons, :equipped, :boolean
    add_column :character_weapons, :carried, :boolean
  end
end
