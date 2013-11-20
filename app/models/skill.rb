class Skill < ActiveRecord::Base
  default_scope { order('name ASC') }

  belongs_to :career
  has_many :character_skills
  has_many :characters, :through => :character_skills
  has_many :weapons
end
