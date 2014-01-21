class AddDamageBonusToWeaponAttachment < ActiveRecord::Migration
  def change
    add_column :weapon_attachments, :damage_bonus, :integer
  end
end
