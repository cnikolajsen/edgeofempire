class ArmorAttachmentAttachmentsGroup < ActiveRecord::Base
  belongs_to :armor_attachment
  belongs_to :attachment_group
end
