class Career < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  has_many :career_talent_trees
  has_many :talent_trees, :through => :career_talent_trees
  accepts_nested_attributes_for :career_talent_trees, :reject_if => :all_blank, :allow_destroy => true
  has_many :career_skills
  has_many :skills, :through => :career_skills
  accepts_nested_attributes_for :career_skills, :reject_if => :all_blank, :allow_destroy => true

  default_scope { order('name ASC') }

  def non_career_skills
    Skill.where('id NOT IN (?)', self.skills.to_a)
  end

end
