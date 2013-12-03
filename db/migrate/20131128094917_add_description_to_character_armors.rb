class AddDescriptionToCharacterArmors < ActiveRecord::Migration
  def change
    add_column :character_armors, :description, :text
  end
end
