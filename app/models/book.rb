class Book < ActiveRecord::Base
  include FriendlyId
  friendly_id :title, :use => :slugged

  def should_generate_new_friendly_id?
    title_changed?
  end

  has_many :weapons
  has_many :armors
  has_many :gears
  has_many :careers
  has_many :talent_trees
  has_many :talents
  has_many :races

  validates :title, presence: true, uniqueness: true
  validates :isbn, presence: true, uniqueness: true
end
