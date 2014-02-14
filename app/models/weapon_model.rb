class WeaponModel < ActiveRecord::Base
  belongs_to :weapon
  belongs_to :character_weapon
end
