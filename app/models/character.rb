class Character < ActiveRecord::Base
  attr_accessible :age, :agility, :brawn, :career_id, :cunning, :gender, :intellect, :name, :presence, :race_id, :willpower, :bio, :character_skills_attributes
  
  validates_presence_of :name
  validates_presence_of :race_id
  validates_presence_of :career_id
  validates_presence_of :gender
  validates_presence_of :brawn
  validates_presence_of :agility
  validates_presence_of :intellect
  validates_presence_of :cunning
  validates_presence_of :presence
  validates_presence_of :willpower
  
  belongs_to :user
  
  has_many :character_skills
  has_many :skills, :through => :character_skills
  
  belongs_to :race
  belongs_to :career
  
  accepts_nested_attributes_for :character_skills
  
  #has_many :skills
  #has_many :talents
end
