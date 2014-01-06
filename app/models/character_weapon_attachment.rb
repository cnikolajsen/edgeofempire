class CharacterWeaponAttachment < ActiveRecord::Base
  belongs_to :character_weapon

  serialize :weapon_attachment_modification_options, JSON
end
