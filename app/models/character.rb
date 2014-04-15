class Character < ActiveRecord::Base
  validates :name, presence: true
  validates :race_id, presence: true
  validates :career_id, presence: true

  include AASM
  include FriendlyId
  friendly_id :slug_candidates, :use => :slugged

  def slug_candidates
    [
      :name,
      [:name, :race_id],
    ]
  end

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
    @character = Character.find(id)

    character_experience_cost = @character.character_experience_costs.sum(:cost)
    starting_experience = if !@character.race.nil? then @character.race.starting_experience else 0 end
    available_experience = starting_experience + @character.experience

    if @character.race.nil? or @character.career.nil?
      false
    elsif character_experience_cost > available_experience
      false
    else
      true
    end
  end

  belongs_to :user

  has_many :character_skills, :dependent => :destroy
  has_many :skills, -> { order 'skills.name' }, :through => :character_skills
  has_many :character_armor, :dependent => :destroy
  has_many :armors, :through => :character_armor
  has_many :character_weapons, :dependent => :destroy
  has_many :weapons, :through => :character_weapons
  has_many :character_gears, :dependent => :destroy
  has_many :gears, :through => :character_gears
  has_many :character_obligations, :dependent => :destroy
  has_many :obligations, :through => :character_obligations
  has_many :character_motivations, :dependent => :destroy
  has_many :motivations, :through => :character_motivations

  has_many :character_talents, :dependent => :destroy
  has_many :talents, :through => :character_talents

  has_many :character_bonus_talents, :dependent => :destroy
  has_many :character_starting_skill_ranks, :dependent => :destroy

  has_many :character_experience_costs

  belongs_to :race
  belongs_to :career

  accepts_nested_attributes_for :character_skills, :allow_destroy => true
  accepts_nested_attributes_for :character_armor, :reject_if => proc { |a| a['armor_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_weapons, :reject_if => proc { |a| a['weapon_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_gears, :reject_if => proc { |a| a['gear_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_obligations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_motivations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_talents, :allow_destroy => true
  accepts_nested_attributes_for :character_starting_skill_ranks, :allow_destroy => true

  default_scope { order('name ASC') }

  def purchased_skills
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'skill', :granted_by => '')
  end

  def selected_skill_ranks_career
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'skill', :granted_by => 'career')
  end

  def selected_skill_ranks_specialization
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'skill', :granted_by => 'specialization')
  end

  def free_skill_ranks_career
    career_free_skill_ranks = if self.race.name == 'Droid' then 6 else 4 end
  end

  def free_skill_ranks_specialization
    specialization_free_skill_ranks = if self.race.name == 'Droid' then 3 else 2 end
  end
end
