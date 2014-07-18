class WeaponCategory < ActiveRecord::Base
  has_many :weapons, -> { order(:name) }
end
