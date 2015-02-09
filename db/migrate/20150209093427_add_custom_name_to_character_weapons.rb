class AddCustomNameToCharacterWeapons < ActiveRecord::Migration
  def change
    add_column :character_weapons, :custom_name, :string
  end
end
