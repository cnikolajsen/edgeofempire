class Weapon < ActiveRecord::Base
  belongs_to :skill
  has_many :weapon_qualities, :through => :weapon_quality_ranks
  has_many :weapon_quality_ranks
  accepts_nested_attributes_for :weapon_quality_ranks
  has_many :characters, :through => :character_weapons
  has_many :character_weapons
  has_many :weapon_models
  accepts_nested_attributes_for :weapon_models, :reject_if => :all_blank, :allow_destroy => true

  default_scope { order('name ASC') }

end
