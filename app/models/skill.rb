class Skill < ActiveRecord::Base
  attr_accessible :characteristic, :description, :name
  
  has_many :characters, :through => :character_skills
  has_many :weapons
end
