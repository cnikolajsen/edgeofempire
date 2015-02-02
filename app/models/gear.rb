# General equipment model.
class Gear < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  validates :name, presence: true, uniqueness: true
  validates :gear_category_id, presence: true

  default_scope { order('gears.name ASC') }

  belongs_to :book
  has_many :gear_models
  belongs_to :gear_category
  accepts_nested_attributes_for :gear_models, reject_if: :all_blank, allow_destroy: true
end
