class Skill < ActiveRecord::Base
  attr_accessible :characteristic, :description, :name, :type
  
  has_many :characters, :through => :character_skills
  has_many :weapons
end
