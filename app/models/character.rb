class Character < ActiveRecord::Base
  attr_accessible :age, :agility, :brawn, :career_id, :cunning, :gender, :intellect, :name, :presence, :race_id, :willpower, :bio, :character_skills_attributes, :character_armor_attributes
  
  validates_presence_of :name
  validates_presence_of :race_id
  validates_presence_of :career_id
  validates_presence_of :brawn
  validates_presence_of :agility
  validates_presence_of :intellect
  validates_presence_of :cunning
  validates_presence_of :presence
  validates_presence_of :willpower
  
  belongs_to :user
  
  has_many :character_skills
  has_many :skills, :through => :character_skills, :order => "name"
  has_one :character_armor
  has_one :armors, :through => :character_armor, :order => "name"
  has_many :character_weapons
  has_many :weapons, :through => :character_weapons, :order => "name"
  has_many :character_gears
  has_many :gears, :through => :character_gears, :order => "name"
  
  belongs_to :race
  belongs_to :career
  
  accepts_nested_attributes_for :character_skills
  accepts_nested_attributes_for :character_armor
  accepts_nested_attributes_for :character_weapons
  accepts_nested_attributes_for :character_gears
  
  
  #has_many :skills
  #has_many :talents
end
