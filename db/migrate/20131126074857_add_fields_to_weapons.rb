class AddFieldsToWeapons < ActiveRecord::Migration
  def change
    add_column :weapons, :encumbrance, :integer
    add_column :weapons, :hard_points, :integer
    add_column :weapons, :rarity, :integer
  end
end
