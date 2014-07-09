class AttachmentGroup < ActiveRecord::Base
  has_many :weapon_attachment_groups
  has_many :weapons, :through => :weapon_attachment_groups
  has_many :armor_attachment_groups
  has_many :armors, :through => :armor_attachment_groups
end
