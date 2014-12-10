class AdversaryArmorAttachment < ActiveRecord::Base
  belongs_to :adversary_armor

  serialize :armor_attachment_modification_options, JSON
end
