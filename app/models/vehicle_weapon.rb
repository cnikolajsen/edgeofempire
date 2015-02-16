class VehicleWeapon < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  validates :name, presence: true, uniqueness: true

  has_many :vehicle_weapon_quality_ranks
  accepts_nested_attributes_for :vehicle_weapon_quality_ranks, reject_if: :all_blank, allow_destroy: true

  def qualities
    qual = []
    vehicle_weapon_quality_ranks.each do |wq|
      if wq.weapon_quality_id
        ranks = wq.ranks && wq.ranks > 0 ? " #{wq.ranks}" : ''
        qual << "#{wq.weapon_quality.name}#{ranks}"
      end
    end
    qual
  end
end
