class CharacterArmorAttachment < ActiveRecord::Base
  belongs_to :character_armor
  belongs_to :armor_attachment

  serialize :armor_attachment_modification_options, JSON
end
