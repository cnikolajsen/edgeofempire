class WeaponAttachmentsWeapon < ActiveRecord::Base
  has_and_belongs_to_many :weapons, join_table: "weapon_attachments_weapons"
  has_and_belongs_to_many :weapon_attachments, join_table: "weapon_attachments_weapons"
end
