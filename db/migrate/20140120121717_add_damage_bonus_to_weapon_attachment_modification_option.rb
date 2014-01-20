class AddDamageBonusToWeaponAttachmentModificationOption < ActiveRecord::Migration
  def change
    add_column :weapon_attachment_modification_options, :damage_bonus, :integer
    add_column :weapon_attachment_modification_options, :weapon_quality_id, :integer
    add_column :weapon_attachment_modification_options, :weapon_quality_rank, :integer
    add_column :weapon_attachment_modification_options, :custom, :string
  end
end
