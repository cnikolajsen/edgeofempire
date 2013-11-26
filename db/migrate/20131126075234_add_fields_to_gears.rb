class AddFieldsToGears < ActiveRecord::Migration
  def change
    add_column :gears, :encumbrance, :integer
    add_column :gears, :rarity, :integer
  end
end
