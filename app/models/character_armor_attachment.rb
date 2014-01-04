class CharacterArmorAttachment < ActiveRecord::Base
  belongs_to :character_armor

  serialize :armor_attachment_modification_options, JSON
end
