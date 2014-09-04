class Skill < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  scope :knowledges, -> { where("name LIKE 'Knowledge%'") }

  default_scope { order('name ASC') }

  belongs_to :career
  has_many :weapons
  has_many :races, :through => :race_talents
end
