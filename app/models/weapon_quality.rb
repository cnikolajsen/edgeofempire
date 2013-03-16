class WeaponQuality < ActiveRecord::Base
  attr_accessible :description, :name, :trigger
  
  #has_many :weapons, :through => :weapon_weapon_qualities
  
  #has_and_belongs_to_many :weapons
  has_many :weapon_quality_ranks
  has_many :weapons, :through => :weapon_quality_ranks
  
  
  #has_and_belongs_to_many :weapons
  #has_many :weapon_weapon_qualities
  
end
