class Skill < ActiveRecord::Base
  default_scope { order('name ASC') }

  belongs_to :career
  has_many :weapons
  has_many :races, :through => :race_talents
end
