class AddWeaponCategoryToWeapons < ActiveRecord::Migration
  def change
    add_column :weapons, :weapon_category_id, :integer, index: true
  end
end