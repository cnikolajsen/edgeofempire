class AddFieldsToArmors < ActiveRecord::Migration
  def change
    add_column :armors, :encumbrance, :integer
    add_column :armors, :hard_points, :integer
    add_column :armors, :rarity, :integer
  end
end
