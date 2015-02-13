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
end
