class Weapon < ActiveRecord::Base
  attr_accessible :crit, :damage, :description, :name, :price, :skill_id, :range
  
  belongs_to :skill
  #has_and_belongs_to_many :weapon_qualities
  has_many :weapon_qualities, :through => :weapon_quality_ranks
  has_many :weapon_quality_ranks
  has_many :characters, :through => :character_weapons
  has_many :character_weapons
end
