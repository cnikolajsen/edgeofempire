class Character < ActiveRecord::Base
  attr_accessible :age, :agility, :brawn, :career, :cunning, :gender, :intellect, :name, :presence, :species, :willpower
  
  validates_presence_of :name, :message => "can't be blank"
  validates_presence_of :species, :message => "can't be blank"
  validates_presence_of :gender, :message => "can't be blank"
  validates_presence_of :brawn, :on => :create, :message => "can't be blank"
  
  belongs_to :user
  
  has_many :skills, :through => :character_skills
  
  #has_many :skills
  #has_many :talents
end
