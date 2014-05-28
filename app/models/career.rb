class Career < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  has_many :talent_trees
  has_many :career_skills
  has_many :skills, :through => :career_skills
  accepts_nested_attributes_for :career_skills, :reject_if => :all_blank, :allow_destroy => true

  default_scope { order('name ASC') }

  def non_career_skills
    Skill.where('id NOT IN (?)', self.skills.to_a)
  end

end
