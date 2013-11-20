class WeaponQuality < ActiveRecord::Base
  
  has_many :weapon_quality_ranks
  has_many :weapons, :through => :weapon_quality_ranks

  default_scope { order('name ASC') }

end
