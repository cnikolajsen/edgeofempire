class Talent < ActiveRecord::Base
  include CharactersHelper

  has_many :character_talents
  has_many :characters, :through => :character_talents
  has_many :races, :through => :race_talents

  validates :name, presence: true, uniqueness: true
  validates :activation, presence: true

  default_scope { order('name ASC') }

  def armormaster(count, character)
    @return = {}
    @return[:soak] = count

    @return
  end

  def deadlyaccuracy(count, character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill
    @return[:on_purchase][:select_options] = [["Choose a combat skill", ""], 'Brawl', 'Gunnery', 'Melee', 'Ranged (Heavy)', 'Ranged (Light)']

    @return
  end

  def dedication(count, character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_characteristic
    @return[:on_purchase][:select_options] = [["Select characteristic", ""], ["Brawn", "brawn"], ["Agility", "agility"], ["Intellect", "intellect"], ["Cunning", "cunning"], ["Willpower", "willpower"], ["Presence", "presence"]]

    @return
  end

  def enduring(count, character)
    @return = {}
    @return[:soak] = count

    @return
  end

  def feralstrength(count, character)
    @return = {}
    @return[:melee_damage_bonus] = count
    @return[:brawl_damage_bonus] = count

    @return
  end

  def forcerating(count, character)
    @return = {}
    @return[:force_rating] = count

    @return
  end

  def grit(count, character)
    @return = {}
    @return[:strain] = count

    @return
  end

  def insight(count, character)
    @return = {}
    @return[:career_skill] = ['perception', 'vigilance']

    @return
  end

  def knowledgespecialization(count, character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill

    options = Array.new(1)
    Skill.where("name LIKE 'Knowledge%'").each do |skill|
      options << [skill.name, skill.id]
    end
    @return[:on_purchase][:select_options] = options

    @return
  end

  def sixthsense(count, character)
    @return = {}
    @return[:ranged_defense] = count

    @return
  end

  def smoothtalker(count, character)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill
    @return[:on_purchase][:select_options] = [['Choose a skill', ''], 'Charm', 'Coerce', 'Negotiate', 'Deceit']

    @return
  end

  def superiorreflexes(count, character)
    @return = {}
    @return[:melee_defense] = count

    @return
  end

  def toughened(count, character)
    @return = {}

    unless count == 0
      @return[:wound] = count["count"] * 2
    end

    @return
  end

  def wellrounded(count, character)
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
