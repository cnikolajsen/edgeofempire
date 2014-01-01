class ArmorQualityRank < ActiveRecord::Base
  validates_presence_of :armor_attachment_id
  validates_presence_of :armor_quality_id

  belongs_to :armor_attachment
  belongs_to :armor_quality
end
