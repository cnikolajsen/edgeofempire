class AdversaryWeaponAttachment < ActiveRecord::Base
  belongs_to :adversary_weapon
  belongs_to :weapon_attachment

  serialize :weapon_attachment_modification_options, JSON
end
