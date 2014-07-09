class WeaponAttachmentsGroup < ActiveRecord::Base
  belongs_to :weapon
  belongs_to :attachment_group
end
