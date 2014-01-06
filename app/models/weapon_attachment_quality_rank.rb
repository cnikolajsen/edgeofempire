class WeaponAttachmentQualityRank < ActiveRecord::Base
  validates_presence_of :weapon_attachment_id
  validates_presence_of :weapon_quality_id

  belongs_to :weapon_attachment
  belongs_to :weapon_quality
end
