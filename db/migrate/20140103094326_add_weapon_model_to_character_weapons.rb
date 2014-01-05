class AddWeaponModelToCharacterWeapons < ActiveRecord::Migration
  def change
    add_column :character_weapons, :weapon_model_id, :integer
  end
end
