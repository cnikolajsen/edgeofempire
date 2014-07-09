class ArmorAttachmentsGroup < ActiveRecord::Base
  belongs_to :armor
  belongs_to :attachment_group
end
