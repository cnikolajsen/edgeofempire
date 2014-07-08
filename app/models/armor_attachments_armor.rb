class ArmorAttachmentsArmor < ActiveRecord::Base
  has_and_belongs_to_many :armors, join_table: "armor_attachments_armors"
  has_and_belongs_to_many :armor_attachments, join_table: "armor_attachments_armors"
end
