class Character < ActiveRecord::Base
  attr_accessible :age, :agility, :brawn, :career_id, :cunning, :gender, :intellect, :name, :presence, :race_id, :willpower, :experience, :credits, :bio, :character_skills_attributes, :character_armor_attributes, :character_weapons_attributes, :character_gears_attributes
  
  validates_presence_of :name
  validates_presence_of :race_id
  validates_presence_of :career_id
  #validates_presence_of :brawn
  #validates_presence_of :agility
  #validates_presence_of :intellect
  #validates_presence_of :cunning
  #validates_presence_of :presence
  #validates_presence_of :willpower
  
  belongs_to :user
  
  has_many :character_skills, :dependent => :destroy
  has_many :skills, :through => :character_skills, :order => "name"
  has_one :character_armor, :dependent => :destroy
  has_one :armors, :through => :character_armor, :order => "name"
  has_many :character_weapons, :dependent => :destroy
  has_many :weapons, :through => :character_weapons, :order => "name"
  has_many :character_gears, :dependent => :destroy
  has_many :gears, :through => :character_gears, :order => "name"

  has_many :character_talents, :dependent => :destroy
  has_many :talents, :through => :character_talents, :order => "name"
  
  belongs_to :race
  belongs_to :career
  
  accepts_nested_attributes_for :character_skills, :allow_destroy => true
  accepts_nested_attributes_for :character_armor, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_weapons, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_gears, :reject_if => :all_blank, :allow_destroy => true

  default_scope order('name ASC')
end
