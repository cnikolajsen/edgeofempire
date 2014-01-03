class AddGearModelToCharacterGears < ActiveRecord::Migration
  def change
    add_column :character_gears, :gear_model_id, :integer
  end
end
