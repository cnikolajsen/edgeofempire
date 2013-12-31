class AddEquippedAndHeldToCharacterGears < ActiveRecord::Migration
  def change
    add_column :character_gears, :carried, :boolean
  end
end
