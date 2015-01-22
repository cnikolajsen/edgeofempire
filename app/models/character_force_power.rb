class CharacterForcePower < ActiveRecord::Base
  belongs_to :character
  belongs_to :force_power

  has_many :character_force_power_upgrades, :dependent => :destroy
  #has_many :force_power_upgrades, :through => :character_force_power_upgrades
  accepts_nested_attributes_for :character_force_power_upgrades, :reject_if => :all_blank, :allow_destroy => true

end
