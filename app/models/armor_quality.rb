class ArmorQuality < ActiveRecord::Base
  has_many :armor_quality_ranks
  has_many :armor_attachments, :through => :armor_quality_ranks

  default_scope { order('name ASC') }
end
