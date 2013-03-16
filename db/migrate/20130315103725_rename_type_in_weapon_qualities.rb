class RenameTypeInWeaponQualities < ActiveRecord::Migration
  def up
    rename_column :weapon_qualities, :type, :trigger
  end
end
