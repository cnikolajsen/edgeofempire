class Character < ActiveRecord::Base
  attr_accessible :age, :agility, :brawn, :career_id, :cunning, :gender, :intellect, :name, :presence, :race_id, :willpower
  
  validates_presence_of :name, :message => "can't be blank"
  validates_presence_of :race_id, :message => "can't be blank"
  validates_presence_of :gender, :message => "can't be blank"
  validates_presence_of :brawn, :on => :create, :message => "can't be blank"
  
  belongs_to :user
  
  has_many :character_skills
  has_many :skills, :through => :character_skills
  
  belongs_to :race
  belongs_to :career
  
  #has_many :skills
  #has_many :talents
end
