class Character < ActiveRecord::Base
  include AASM

  aasm do
    state :creation, :initial => true
    state :active
    state :retired

    event :activate do
      transitions :from => :creation, :to => :active, :guard => :experience_exceeded?
    end

    event :retire do
      transitions :from => :active, :to => :retired
    end

    event :set_create do
      transitions :to => :creation
    end
  end

  def experience_exceeded?
    cost = ApplicationController.helpers.character_experience_cost(id)

    if cost[:total_cost] > experience
      false
    else
      true
    end

  end

  validates_presence_of :name
  validates :race_id, presence: true, if: ":character_species.nil?"
  validates :career_id, presence: true, if: ":character_career.nil?"

  belongs_to :user

  has_many :character_skills, :dependent => :destroy
  has_many :skills, :through => :character_skills
  has_one :character_armor, :dependent => :destroy
  has_one :armors, :through => :character_armor
  has_many :character_weapons, :dependent => :destroy
  has_many :weapons, :through => :character_weapons
  has_many :character_gears, :dependent => :destroy
  has_many :gears, :through => :character_gears
  has_many :character_obligations, :dependent => :destroy
  has_many :obligations, :through => :character_obligations

  has_many :character_talents, :dependent => :destroy
  has_many :talents, :through => :character_talents

  has_many :character_bonus_talents, :dependent => :destroy
  has_many :character_starting_skill_ranks, :dependent => :destroy

  belongs_to :race
  belongs_to :career

  accepts_nested_attributes_for :character_skills, :allow_destroy => true
  accepts_nested_attributes_for :character_armor, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_weapons, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_gears, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_obligations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_talents, :allow_destroy => true
  accepts_nested_attributes_for :character_starting_skill_ranks, :allow_destroy => true

  default_scope { order('name ASC') }

end
