class WeaponQualityRank < ActiveRecord::Base
  validates_presence_of :weapon_id
  validates_presence_of :weapon_quality_id
  
  belongs_to :weapon
  belongs_to :weapon_quality
end
