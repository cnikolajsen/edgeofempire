class WeaponQualityRank < ActiveRecord::Base
  #attr_accessible :ranks, :weapon_id, :weapon_quality_id
  
  validates_presence_of :weapon_id
  validates_presence_of :weapon_quality_id
  
  belongs_to :weapon
  belongs_to :weapon_quality
end
