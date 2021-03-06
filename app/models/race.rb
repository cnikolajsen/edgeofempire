class Race < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  default_scope { order('name ASC') }

  has_many :race_skills, :dependent => :destroy
  has_many :skills, :through => :race_skills
  accepts_nested_attributes_for :race_skills, :reject_if => :all_blank, :allow_destroy => true
  has_many :race_talents, :dependent => :destroy
  has_many :talents, :through => :race_talents
  accepts_nested_attributes_for :race_talents, :reject_if => :all_blank, :allow_destroy => true

  # :skill_rank_choice = [['label', skill_id]]
  # :skill_rank_creation_limit = [[skill_id, limit]]

  def human_traits
    traits = {
      :bonus_non_class_skill_ranks => 2,
    }
  end

  def corellianhuman_traits
    traits = {
      :skill_rank_choice => [['Piloting (Planetary)', 19], ['Piloting (Space)', 33]],
      :skill_rank_creation_limit => [[19, 3], [33, 3]],
    }
  end

  def twilek_traits
    traits = {
      :skill_rank_choice => [['Charm', 4], ['Deception', 9]]
    }
  end

  def gand_traits
    traits = {
      :sub_species => {
        'Ammonia breather' => {
          :exp_bonus => 10,
          :description => 'You breathe an ammonia gas mixture, and start playing with an ammonia respirator. Oxygen is a dangerous atmosphere with Rating 8.'
        },
        'Lungless' => {
          :exp_bonus => 0,
          :description => 'You do not have lungs, and are immune to suffocation.'
        }
      },
    }
  end

  def gran_traits
    traits = {
      :skill_rank_choice => [['Charm', 4], ['Negotiation', 17]]
    }
  end

end