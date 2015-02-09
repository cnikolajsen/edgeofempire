class AddCustomNameToCharacterArmors < ActiveRecord::Migration
  def change
    add_column :character_armors, :custom_name, :string
  end
end
