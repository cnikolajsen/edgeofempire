class AddDescriptionToCharacterWeapons < ActiveRecord::Migration
  def change
    add_column :character_weapons, :description, :text
  end
end
