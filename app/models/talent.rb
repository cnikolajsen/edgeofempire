class Talent < ActiveRecord::Base
  include CharactersHelper

  has_many :character_talents
  has_many :characters, through: :character_talents
  has_many :races, through: :race_talents

  validates :name, presence: true, uniqueness: true
  validates :activation, presence: true

  default_scope { order('name ASC') }

  def armormaster(count, _character)
    @return = {}
    @return[:soak] = count

    @return
  end

  def basiccombattraining(_count, _character)
    @return = {}
    @return[:career_skill] = ['Brawl', 'Ranged (Light)']

    @return
  end

  def deadlyaccuracy(_count, _character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill
    @return[:on_purchase][:select_options] = [['Choose a combat skill', ''], 'Brawl', 'Gunnery', 'Melee', 'Ranged (Heavy)', 'Ranged (Light)']

    @return
  end

  def dedication(_count, _character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_characteristic
    @return[:on_purchase][:select_options] = [['Select characteristic', ''], %w(Brawn brawn), %w(Agility agility), %w(Intellect intellect), %w(Cunning cunning), %w(Willpower willpower), %w(Presence presence)]

    @return
  end

  def enduring(count, _character)
    @return = {}
    @return[:soak] = count

    @return
  end

  def feralstrength(count, _character)
    @return = {}
    @return[:melee_damage_bonus] = count
    @return[:brawl_damage_bonus] = count

    @return
  end

  def forcerating(count, _character)
    @return = {}
    @return[:force_rating] = count

    @return
  end

  def grit(count, _character)
    @return = {}
    @return[:strain] = count

    @return
  end

  def insight(_count, _character)
    @return = {}
    @return[:career_skill] = %w(Perception Vigilance)

    @return
  end

  def knowledgespecialization(_count, _character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill

    options = []
    Skill.knowledges.each do |skill|
      options << [skill.name, skill.id]
    end
    @return[:on_purchase][:select_options] = options

    @return
  end

  def sixthsense(count, _character)
    @return = {}
    @return[:ranged_defense] = count

    @return
  end

  def smoothtalker(_count, _character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill
    @return[:on_purchase][:select_options] = [['Choose a skill', ''], 'Charm', 'Coerce', 'Negotiate', 'Deceit']

    @return
  end

  def superiorreflexes(count, _character)
    @return = {}
    @return[:melee_defense] = count

    @return
  end

  def toughened(count, _character)
    @return = {}
    @return[:wound] = count['count'] * 2 unless count == 0
    @return
  end

  def wellrounded(_count, character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 2
    @return[:on_purchase][:type] = :select_skill

    options = Array.new(1)
    Skill.all.each do |skill|
      unless is_career_skill(skill.id, true, character)
        options << [skill.name, skill.id]
      end
    end
    @return[:on_purchase][:select_options] = options

    @return
  end
end
