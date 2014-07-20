class WeaponCategory < ActiveRecord::Base
  has_many :weapons, -> { order(:name) }

  validates :name, presence: true, uniqueness: true
end
