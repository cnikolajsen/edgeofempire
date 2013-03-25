class Skill < ActiveRecord::Base
  attr_accessible :characteristic, :description, :name
  
  belongs_to :career
  has_many :character_skills
  has_many :characters, :through => :character_skills
  has_many :weapons
end
