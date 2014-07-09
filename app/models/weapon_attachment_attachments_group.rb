class WeaponAttachmentAttachmentsGroup < ActiveRecord::Base
  belongs_to :weapon_attachment
  belongs_to :attachment_group
end
