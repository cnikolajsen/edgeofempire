class CharacterWeaponAttachment < ActiveRecord::Base
  belongs_to :character_weapon
  belongs_to :weapon_attachment

  serialize :weapon_attachment_modification_options, JSON
end
