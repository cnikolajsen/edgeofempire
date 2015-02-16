class Starship < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  validates :name, presence: true, uniqueness: true
  validates :starship_category_id, presence: true

  belongs_to :book
  belongs_to :starship_category

  has_many :starship_vehicle_weapons
  accepts_nested_attributes_for :starship_vehicle_weapons, reject_if: :all_blank, allow_destroy: true
  has_many :starship_crews
  accepts_nested_attributes_for :starship_crews, reject_if: :all_blank, allow_destroy: true

  def crew
    crew = []
    starship_crews.each do |c|
      crew << "#{c.qty} #{c.description}"
    end
    crew.reverse!
  end

  def hyperdrive
    hd = []
    if hyperdrive_class_primary > 0
      hd << "Primary: Class #{hyperdrive_class_primary}"
    end
    if hyperdrive_class_secondary > 0
      hd << "Backup: Class #{hyperdrive_class_secondary}"
    end

    if hd.empty?
      hd << 'None'
    end

    hd
  end

  def weapons
    weapons = []
    starship_vehicle_weapons.each do |w|
      if w.vehicle_weapon_id
        grouping = w.grouping.blank? ? '' : " #{w.grouping}"
        turreted = w.turret? ? ' Turret' : ''
        qualities = w.vehicle_weapon.qualities.any? ? "; #{w.vehicle_weapon.qualities.to_sentence(two_words_connector: ', ')}" : ''
        weapons << "#{w.mounting}#{turreted} Mounted#{grouping} #{w.vehicle_weapon.name} (Fire Arc #{w.firing_arc}; Damage #{w.vehicle_weapon.damage}; Critical #{w.vehicle_weapon.critical}; Range [#{w.vehicle_weapon.range}]#{qualities})"
      end
    end
    weapons
  end
end
