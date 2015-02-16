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
end
